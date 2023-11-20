//
//  ViewController.swift
//  WA8
//
//  Created by 郭 on 2023/11/14.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    let mainScreen = LoginCoverScreen()

    let childProgressView = ProgressSpinnerViewController()
    
    
    let database = Firestore.firestore()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?
   
    
    override func loadView() {
        view = mainScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true

        mainScreen.buttonSignup.addTarget(self, action: #selector(buttonSignup), for: .touchUpInside)
        mainScreen.buttonLogin.addTarget(self, action: #selector(buttonLogin), for: .touchUpInside)
    }
    
    
    @objc func buttonSignup(){
        let registerScreen = RegisterViewController()
        self.navigationController?.pushViewController(registerScreen, animated: true)
    }
    
    

    
    @objc func buttonLogin(){
        if let email = mainScreen.textFieldName.text,
           let password = mainScreen.textFieldPassword.text{
            if !email.isEmpty && !password.isEmpty{
                if !isValidEmail(email){
                    showAlertText(text:"please enter valid email~~")
                }
                
                self.signInToFirebase(email: email, password: password)
                
            }else{
                showAlertText(text:"please enter all information")
            }
        }
    }
    

    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlertText(text:String){
        let alert = UIAlertController(
            title: "Error",
            message: "\(text)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}


