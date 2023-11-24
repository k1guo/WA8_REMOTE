//
//  MainScreenController.swift
//  WA8
//
//  Created by 郭 on 2023/11/17.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
        
        title = "My Contact"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        mainScreen.tableViewChatLists.delegate = self
        mainScreen.tableViewChatLists.dataSource = self
        
        mainScreen.tableViewChatLists.separatorStyle = .none
        
        view.bringSubviewToFront(mainScreen.floatingButtonSetting)
        
        mainScreen.floatingButtonSetting.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let strongSelf = self else { return }
            
            if let user = user {
                strongSelf.handleUserLoggedIn(user)
            } else {
                strongSelf.handleUserLoggedOut()
            }
        }
    }

    func handleUserLoggedIn(_ user: User) {
        print("User is logged in.")
        self.currentUser = user
        mainScreen.labelText.text = "Let's Chat!"
        if let url = self.currentUser?.photoURL{
            self.mainScreen.currentUserPic.loadRemoteImage(from: url)
        }
        setupLogoutButton()
        loadContacts(userName: user.displayName ?? "")
    }

    func handleUserLoggedOut() {
        print("User is not logged in.")
        //MARK: Reset the profile pic...
        self.mainScreen.currentUserPic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        // Handle user not logged in, like redirecting to login screen
    }

    func setupLogoutButton() {
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
    }

    func loadContacts(userName: String) {
        database.collection("users").whereField("name", isNotEqualTo: userName).getDocuments { [weak self] (querySnapshot, err) in
            
            //MARK: let controllerSelf = self : self is this page's controller
            guard let controllerSelf = self else { return }
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                controllerSelf.contactsList.removeAll()
                for document in querySnapshot!.documents {
                    do {
                        let contact = try document.data(as: Contact.self)
                        controllerSelf.contactsList.append(contact)
                    } catch {
                        print(error)
                    }
                }
                controllerSelf.mainScreen.tableViewChatLists.reloadData()
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
                //MARK: else create a new database for new chat session
                print("No chats found in chatDetail collection.")
    
                self.database.collection("chats").document(self.chatIdentifier!).setData([:]) { error in
                    if let error = error {
                        print("Error creating new chat session: \(error)")
                    } else {
                        print("New chat session created successfully.")
                    }
            }
        }
    }
    
        //MARK: pop to new screen
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
    
    @objc func settingButtonTapped(){
        let editScreen = EditProfileController()
        self.navigationController?.pushViewController(editScreen, animated: true)
        
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
        self.otherName = contactsList[indexPath.row].name
        let otherId = contactsList[indexPath.row].userId
        guard let currentId = self.currentUser?.uid else {
            //MARK: if no current user return something
            return
        }
        //MARK: create new id and this id sort by their uid
        let sortedIds = [otherId, currentId].sorted()
        self.chatIdentifier = sortedIds.joined(separator: "_")
        self.getAndReloadMessage()
        }
}
