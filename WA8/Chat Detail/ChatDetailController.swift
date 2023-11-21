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


class ChatDetailController: UIViewController {
    
    let chatScreen = ChatDetailScreen()
    
    var currentUser:FirebaseAuth.User?
    
    var chatSession = [ChatMessage]()
    
    let database = Firestore.firestore()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var chatIdentifier: String?
    
    var otherName:String?
//    var chatData: ChatData?
    
    override func loadView() {
        view = chatScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = " chat message page"
        
        print(chatSession)
        
        chatScreen.chatDetailTable.delegate = self
        chatScreen.chatDetailTable.dataSource = self

        //MARK: removing the separator line...
        chatScreen.chatDetailTable.separatorStyle = .none
//        self.chatSession.reload()
        self.chatScreen.chatDetailTable.reloadData()
        
  
        chatScreen.buttonSent.addTarget(self, action: #selector(onSentButtonTapped), for: .touchUpInside)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)

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
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                print("user is empty")
                
            }else{
                print("user not empty12345")
                self.currentUser = user
        
                self.database.collection("chats").document(self.chatIdentifier!).collection("chatDetail").getDocuments() { (querySnapshot, err) in
                  if let err = err {
                    print("Error getting documents: \(err)")
                  } else {
                      self.chatSession.removeAll()
                      for document in querySnapshot!.documents {

                          do{
                              let info = try document.data(as: ChatMessage.self)
                              self.chatSession.append(info)
                              print(info,"info here111")

                          }catch{
                              print(error)
                          }
                    }

                      print("print the message list     !")
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

            // 将 ChatMessage 转换
             let messageData: [String: Any] = [
                 "senderId": newMessage.senderId,
                 "message": newMessage.message,
                 "timestamp": Timestamp(date: newMessage.timestamp)
             ]

             // 存储数据
            let refDoc = self.database.collection("chats").document(self.chatIdentifier!)
            refDoc.collection("chatDetail").document().setData(messageData, merge: true) { error in
                 if let error = error {
                     print("Error writing document: \(error)")
                 } else {
                     self.chatSession.append(newMessage)
                     self.chatScreen.chatDetailTable.reloadData()
                     self.scrollToBottom()
                     print("Document successfully written!")
                 }
             }
            

        }

    }
    
}
    



extension ChatDetailController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatSession.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.ChatDetailTableViewID, for: indexPath) as!
            ChatDetailTableViewCell
        print( chatSession[indexPath.row].message,"printttt here")
        cell.labelMessage.text = chatSession[indexPath.row].message
        // 格式化时间戳
        self.chatSession.sort { $0.timestamp < $1.timestamp }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: chatSession[indexPath.row].timestamp)
        
        if chatSession[indexPath.row].senderId == self.currentUser!.uid{
            print("they are equal")
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
        
        
        cell.labelTime.text = dateString
       
        return cell
    }
    

}


    

