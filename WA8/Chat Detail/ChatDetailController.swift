//
//  ChatDetailController.swift
//  WA8
//
//  Created by 郭 on 2023/11/17.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI
import FirebaseStorage


class ChatDetailController: UIViewController {
    
    let chatScreen = ChatDetailScreen()
    
    var currentUser:FirebaseAuth.User?
    
    var chatSession = [ChatSessionContent]()
    
    let database = Firestore.firestore()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    let storage = Storage.storage()
    
    var chatIdentifier: String?
    
    var otherName:String?
    
    var pickedImage:UIImage?
    
    override func loadView() {
        view = chatScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = otherName
        
        print(chatSession)
        
        chatScreen.chatDetailTable.delegate = self
        chatScreen.chatDetailTable.dataSource = self
        
        chatScreen.chatDetailTable.separatorStyle = .none
        
        self.chatSession.sort { $0.timestamp < $1.timestamp }
        self.chatScreen.chatDetailTable.reloadData()
        
        chatScreen.sentImageButton.menu = getMenuImagePicker()
        chatScreen.buttonSent.addTarget(self, action: #selector(onSentButtonTapped), for: .touchUpInside)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    //MARK: take Photo using Camera...
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    //MARK: pick Photo using Gallery...
    func pickPhotoFromGallery(){
        print("Gallery picker is called")
        //MARK: Photo from Gallery...
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
    
    //MARK: Hide Keyboard...
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let numberOfSections = self.chatScreen.chatDetailTable.numberOfSections
            let numberOfRows = self.chatScreen.chatDetailTable.numberOfRows(inSection: numberOfSections - 1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                self.chatScreen.chatDetailTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        handleAuth = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                print("user is empty")
            } else {
                print("user not empty")
                self.currentUser = user
                self.database.collection("chats").document(self.chatIdentifier!).collection("chatDetail").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        self.chatSession.removeAll()
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if let _ = data["message"] as? String {
                                if let message = try? document.data(as: ChatMessage.self) {
                                    self.chatSession.append(.message(message))
                                }
                            } else if let _ = data["imageUrl"] as? String {
                                if let image = try? document.data(as: ChatImage.self) {
                                    self.chatSession.append(.image(image))
                                }
                            }
                        }
                        self.chatSession.sort { $0.timestamp < $1.timestamp }
                        print("print the message list")
                        self.chatScreen.chatDetailTable.reloadData()
                        self.scrollToBottom()
                    }
                }
            }
        }
        scrollToBottom()
    }

    
    @objc func onSentButtonTapped(){
        if let senderId = currentUser?.uid,let message = chatScreen.textField.text{
            let newMessage = ChatMessage(senderId: senderId, message: message, timestamp:  Date())
            print("here")
            print(newMessage.self)
            
            let messageData: [String: Any] = [
                "senderId": newMessage.senderId,
                "message": newMessage.message,
                "timestamp": Timestamp(date: newMessage.timestamp)
            ]
            
            let refDoc = self.database.collection("chats").document(self.chatIdentifier!)
            refDoc.collection("chatDetail").document().setData(messageData, merge: true) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    self.chatSession.append(.message(newMessage))
                    self.chatScreen.chatDetailTable.reloadData()
                    self.scrollToBottom()
                    print("Document successfully written!")
                }
            }
        }
    }
    
    func StorePhotoInFireStore(photoURL: URL?) {
        guard let senderId = currentUser?.uid, let validPhotoURL = photoURL else {
            print("Error: Invalid user ID or photo URL")
            return
        }

        let newImage = ChatImage(senderId: senderId, imageUrl: validPhotoURL, timestamp: Date())
        print("here")
        print(newImage.self)

        let messageData: [String: Any] = [
            "senderId": newImage.senderId,
            "imageUrl": newImage.imageUrl.absoluteString,  // 使用有效的 URL
            "timestamp": Timestamp(date: newImage.timestamp)
        ]

        let refDoc = self.database.collection("chats").document(self.chatIdentifier!)
        refDoc.collection("chatDetail").document().setData(messageData, merge: true) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                self.chatSession.append(.image(newImage))
                self.chatScreen.chatDetailTable.reloadData()
                self.scrollToBottom()
                print("Document successfully written!")
            }
        }
    }

    
    
    
    func uploadProfilePhotoToStorage(){
        var profilePhotoURL:URL?
        
        //MARK: Upload the profile photo if there is any...
        if let image = pickedImage{
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesUsers")
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                
                let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil{
                                profilePhotoURL = url
                                self.StorePhotoInFireStore(photoURL: profilePhotoURL)
                            }
                        })
                    }
                })
            }
        }else{
            print("here444")
            self.StorePhotoInFireStore(photoURL: profilePhotoURL)
        }
    }
    
}
    



extension ChatDetailController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatSession.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: chatSession[indexPath.row].timestamp)
        
        let content = chatSession[indexPath.row]
        switch content {
           case .message(let chatMessage):
               // 处理文本消息
               let cell = tableView.dequeueReusableCell(withIdentifier: Configs.ChatDetailTableViewID, for: indexPath) as! ChatDetailTableViewCell
               cell.labelMessage.isHidden = false
               cell.messageImageView.isHidden = true
               cell.labelMessage.text = chatMessage.message
            
            
            cell.labelTime.text = dateString
            if chatMessage.senderId == self.currentUser!.uid{
                       cell.wrapperCellView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                if let sender = self.currentUser?.displayName{
                    cell.labelSenderName.text =  "sender: \(sender)"
                    }
                   }else{
                       cell.wrapperCellView.backgroundColor = UIColor.white
                       if let name = otherName{
                           cell.labelSenderName.text =  "sender: \(name)"
                       }
                   }
               return cell

           case .image(let chatImage):
               // 处理图片消息
               let cell = tableView.dequeueReusableCell(withIdentifier: Configs.ChatDetailTableViewID, for: indexPath) as! ChatDetailTableViewCell
               cell.labelMessage.isHidden = true
               cell.messageImageView.isHidden = false
               // 假设您有一个方法 loadRemoteImage 来异步加载和显示图片
            cell.messageImageView.loadRemoteImage(from: chatImage.imageUrl)
               
            if let sender = self.currentUser?.displayName{
                cell.labelSenderName.text =  "sender: \(sender)"
                }
            cell.labelTime.text = dateString
            if chatImage.senderId == self.currentUser!.uid{
                       cell.wrapperCellView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                if let sender = self.currentUser?.displayName{
                    cell.labelSenderName.text =  "sender: \(sender)"
                    }
                   }else{
                       cell.wrapperCellView.backgroundColor = UIColor.white
                       if let name = otherName{
                           cell.labelSenderName.text =  "sender: \(name)"
                       }
                   }
               return cell
           }
    }

}


    


//MARK: adopting required protocols for PHPicker...
extension ChatDetailController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        let itemprovider = results.map(\.itemProvider)
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(
                    ofClass: UIImage.self,
                    completionHandler: { (image, error) in
                        DispatchQueue.main.async{
                            if let uwImage = image as? UIImage{
                                self.pickedImage = uwImage
                                self.uploadProfilePhotoToStorage()
                            }
                        }
                    }
                )
            }
        }
    }
}


//MARK: adopting required protocols for UIImagePicker...
extension ChatDetailController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.pickedImage = image
            self.uploadProfilePhotoToStorage()
        }else{
            // Do your thing for No image loaded...
        }
    }
}

