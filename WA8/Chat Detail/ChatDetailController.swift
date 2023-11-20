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
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                print("user is empty")
                
            }else{
                print("user not empty")

                self.createNewMessageInChat()
            }
        }
    }
    
    // 这里需要将消息添加到数据库的代码 unfinish
    func createNewMessageInChat(){
        if let senderId = currentUser?.uid,let message = chatScreen.textField.text{
            let newMessage = ChatMessage(senderId: senderId, message: message, timestamp:  Date())

         

        }
        
        
    }
   
    }
    

    

