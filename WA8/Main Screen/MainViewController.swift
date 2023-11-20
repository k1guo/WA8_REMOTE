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

//""


class MainViewController: UIViewController {
    
    var contactsList = [Contact]()
    
    let database = Firestore.firestore()
    
    var here:String?
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?
    
//    var chatData: ChatData?
    
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
//                print(self.currentUser?.displayName!)
                    
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

        print(self.currentUser?.uid,"here should be current user's id")
        if let uwId = self.currentUser?.uid{
//            这里是通过sort双方的uid 创建一个独一无二的chatIdentifier，通过这个chatIdentifier可以查看双方的聊天记录
            let userIds = [otherId, uwId]
            let sortedIds = userIds.sorted()
            let chatIdentifier = sortedIds.joined(separator: "_")
            print(chatIdentifier)
            
            self.database.collection("chats").whereField("ChatUsers", isEqualTo: chatIdentifier)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        // 检查是否有文档，有文档的话要在chat detail 那边reload
                        if let snapshot = querySnapshot, snapshot.documents.isEmpty == false {
                            print("here")
                            for document in snapshot.documents {
                                print("\(document.documentID) => \(document.data())")
                            }
                        } else {
                            
                            print("No chats found. Creating a new chat.")
                            // 没有找到文档，使用 chatIdentifier 作为文档ID来创建一个新的文档
                            self.database.collection("chats").document(chatIdentifier).setData([:]) { error in
                                if let error = error {
                                    print("Error creating new chat session: \(error)")
                                } else {
                                    print("New chat session created successfully with ID: \(chatIdentifier)")
                                }
                            }

                        }
                    }
                    
//                    let chatScreen = ChatDetailController()
//                    chatScreen.chatIdentifier=self.chatIdentifier
//                    self.navigationController?.pushViewController(chatScreen, animated: true)
                }
        }
        
        
    }
        
        
        
        
    }
