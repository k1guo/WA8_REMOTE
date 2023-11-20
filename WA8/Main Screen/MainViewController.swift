//
//  MainScreenController.swift
//  WA8
//
//  Created by 郭 on 2023/11/17.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import Foundation


class MainViewController: UIViewController {
    
    var contactsList = [Contact]()
    
    let database = Firestore.firestore()
    
    var here:String?
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?

    let mainScreen = MainScreen()
    
    var chatIdentifier: String?
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "My Chat List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: patching table view delegate and data source...
        mainScreen.tableViewChatLists.delegate = self
        mainScreen.tableViewChatLists.dataSource = self
        
        //MARK: removing the separator line...
        mainScreen.tableViewChatLists.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                print("user is empty")
                
            }else{
                print("user not empty")
                self.currentUser = user
                
//                这个是现在登录的这个用户的名字
                print(self.currentUser?.displayName!)
                    
                self.database.collection("users").whereField("name", isNotEqualTo:self.currentUser?.displayName! ).getDocuments() { (querySnapshot, err) in
                  if let err = err {
                    print("Error getting documents: \(err)")
                  } else {
                      self.contactsList.removeAll()
                      for document in querySnapshot!.documents {
                        
                          do{
                              let contact  = try document.data(as: Contact.self)
                              self.contactsList.append(contact)
                           
                          }catch{
                              print(error)
                          }
                    }
                      
                      print("print the contacts list     !")
                      self.mainScreen.tableViewChatLists.reloadData()
                  }
                }
   
            }
            
        }
        
    }
    func getAndReloadMessage(){
        print(self.chatIdentifier,"here")
//        开始对数据库进行查询 查看这两个人是否有聊天记录
        
        let refDoc = self.database.collection("chats").document(self.chatIdentifier!).collection("chatDetail")
        refDoc.getDocuments { (querySnapshot, error) in
            if let error = error {
                // 处理错误
                print("Error getting documents: \(error)")
            } else {
                // 检查是否有文档
                if let snapshot = querySnapshot, !snapshot.isEmpty {
//                    下面是有文档的情况
                    print("Documents found in chatDetail collection.")
                    for document in snapshot.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                } else {
//                    下面是没有文档的情况，创建新的聊天文档
                    print("No chats found in chatDetail collection.")
    
                    self.database.collection("chats").document(self.chatIdentifier!).setData([:]) { error in
                        if let error = error {
                            print("Error creating new chat session: \(error)")
                        } else {
                            print("New chat session created successfully with ID: \(self.chatIdentifier)")
                        }
                    }
                }
            }
        }
        
//        处理完数据库 进入到新的页面
        let chatScreen = ChatDetailController()
        chatScreen.chatIdentifier=self.chatIdentifier
        chatScreen.currentUser = self.currentUser
        self.navigationController?.pushViewController(chatScreen, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewContactsID, for: indexPath) as! ContactsTableViewCell
        cell.labelName.text = contactsList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let otherId = contactsList[indexPath.row].userId
        if let uwId = self.currentUser?.uid{
//            这里是通过sort双方的uid 创建一个独一无二的chatIdentifier，通过这个chatIdentifier可以查看双方的聊天记录
            let userIds = [otherId, uwId]
            let sortedIds = userIds.sorted()
            self.chatIdentifier = sortedIds.joined(separator: "_")
            self.getAndReloadMessage()
                }
        }
 
}
