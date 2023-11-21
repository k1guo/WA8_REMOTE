//
//  SignUpController.swift
//  WA8
//
//  Created by 郭 on 2023/11/14.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class RegisterViewController: UIViewController {

    let registerScreen = RegisterScreen()
    
    var currentUser:FirebaseAuth.User?
    
    let database = Firestore.firestore()
    
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        registerScreen.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)

    }


    //MARK: Hide Keyboard...
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    @objc func onRegisterTapped(){
        //MARK: creating a new user on Firebase...
        registerNewAccount()
    }
    
}
