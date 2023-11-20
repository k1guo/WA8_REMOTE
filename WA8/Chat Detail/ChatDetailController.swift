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
        // Do any additional setup after loading the view.
        chatScreen.buttonSent.addTarget(self, action: #selector(onSentButtonTapped), for: .touchUpInside)
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
                     print("Document successfully written!")
                 }
             }

        }

    }
    

   
    }
    

    

