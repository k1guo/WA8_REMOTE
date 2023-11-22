//
//  RightBarButtonManager.swift
//  WA8
//
//  Created by 郭 on 2023/11/15.
//

import UIKit
import FirebaseAuth

extension ViewController{
     
    @objc func onSignInBarButtonTapped(){
        let signInAlert = UIAlertController(
            title: "Sign In / Register",
            message: "Please sign in to continue.",
            preferredStyle: .alert)
        
        //MARK: setting up email textField in the alert...
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter email"
            textField.contentMode = .center
            textField.keyboardType = .emailAddress
        }
        
        //MARK: setting up password textField in the alert...
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter password"
            textField.contentMode = .center
            textField.isSecureTextEntry = true
        }
        
        
        //MARK: Sign In Action...
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: {(_) in
            if let email = signInAlert.textFields![0].text,
               let password = signInAlert.textFields![1].text{
                //MARK: sign-in logic for Firebase...
                self.signInToFirebase(email: email, password: password)
                
            }
        })
        
        //MARK: Register Action...
        let registerAction = UIAlertAction(title: "Register", style: .default, handler: {(_) in
            //MARK: logic to open the register screen...
            let registerViewController = RegisterViewController()
            self.navigationController?.pushViewController(registerViewController, animated: true)
            
        })
        
        //MARK: action buttons...
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        self.present(signInAlert, animated: true, completion: {() in
            //MARK: hide the alerton tap outside...
            signInAlert.view.superview?.isUserInteractionEnabled = true
            signInAlert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(self.onTapOutsideAlert))
            )
        })
    }
    
    @objc func onTapOutsideAlert(){
        self.dismiss(animated: true)
    }
    
    func signInToFirebase(email: String, password: String){
           //MARK: can you display progress indicator here?
           //MARK: authenticating the user...
           showActivityIndicator()
           Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
                self.hideActivityIndicator()
               if error == nil{
                   print("sign in successful")
                    let mainScreen = MainViewController()
                   self.navigationController?.setViewControllers([mainScreen], animated: true)

               }else{
                   self.showAlertText(text:"password or user name fail. Please try again~")
               }
           })
       }
}
