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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                print("user is empty")
                
            }else{
                print("user not empty12345")
                self.currentUser = user
                
//                这个是现在登录的这个用户的名字
                print(self.currentUser?.displayName!)
                    
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
                  }
                }
   
            }
            
        }
        
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
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: chatSession[indexPath.row].timestamp)
        cell.labelTime.text = dateString
        return cell
    }
    

}


    

