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
    
    var chatSession = [ChatMessage]()
    
    var contactsList = [Contact]()
    
    let database = Firestore.firestore()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?

    let mainScreen = MainScreen()
    
    var chatIdentifier: String?
    
    var otherName: String?
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "My Chat List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mainScreen.tableViewChatLists.delegate = self
        mainScreen.tableViewChatLists.dataSource = self
        
        mainScreen.tableViewChatLists.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                print("user is empty")
                
            }else{
                print("user not empty")
                self.currentUser = user
                //MARK: user is logged in...
                let barIcon = UIBarButtonItem(
                    image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"),
                    style: .plain,
                    target: self,
                    action: #selector(self.onLogOutBarButtonTapped)
                )
                let barText = UIBarButtonItem(
                    title: "Logout",
                    style: .plain,
                    target: self,
                    action: #selector(self.onLogOutBarButtonTapped)
                )
                
                self.navigationItem.rightBarButtonItems = [barIcon, barText]
                
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
                
                self.currentUser = user
            }
        }
    }
    
    func getAndReloadMessage(){
        let refDoc = self.database.collection("chats").document(self.chatIdentifier!).collection("chatDetail")
        refDoc.getDocuments { (querySnapshot, error) in
            if let error = error {
                // error
                print("Error getting documents: \(error)")
            } else {
//                else create a new database for new chat session
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
    
//        pop to new screen
        let chatScreen = ChatDetailController()
        chatScreen.chatIdentifier=self.chatIdentifier
        chatScreen.currentUser = self.currentUser
        chatScreen.otherName = self.otherName
        self.navigationController?.pushViewController(chatScreen, animated: true)
    }
    
    @objc func onLogOutBarButtonTapped(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
                do{
                    try Auth.auth().signOut()
                }catch{
                    print("Error occured!")
                }
            let loginViewController = ViewController()
            self.navigationController?.setViewControllers([loginViewController], animated: true)
            })
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(logoutAlert, animated: true)
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
        self.otherName = contactsList[indexPath.row].name
      
        if let uwId = self.currentUser?.uid{
//           create new id and this id sort by their uid
            let userIds = [otherId, uwId]
            let sortedIds = userIds.sorted()
            self.chatIdentifier = sortedIds.joined(separator: "_")
            self.getAndReloadMessage()
                }
        }
 
}
