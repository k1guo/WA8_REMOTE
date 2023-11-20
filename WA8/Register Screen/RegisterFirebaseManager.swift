//
//  RegisterFirebaseManager.swift
//  WA8
//
//  Created by 郭 on 2023/11/15.
//

import Foundation
import FirebaseAuth
import UIKit

extension RegisterViewController{
    
    func registerNewAccount(){
        showActivityIndicator()
        //MARK: create a Firebase user with email and password...
        if let name = registerScreen.textFieldName.text,
           let email = registerScreen.textFieldEmail.text,
           let password = registerScreen.textFieldPassword.text,
           let reEnterPassword = registerScreen.textFieldVerifyPassword.text{
            
            //            login screen 部分的valid enter还没有写
            if(password != reEnterPassword){
            showAlertText(text: "Two password not match!")
            }
            //W1988445
            if isValidEmail(email){
                Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                    if error == nil{
//                        register sucess and get this new created user's u id
                        let uid = result!.user.uid
                       
                        //MARK: the user creation is successful...
                        let contact = Contact(name: name, email: email, userId: uid )
                       
                            
                            let collectionContacts = self.database
                                   .collection("users")
                                   .document(name)
                                  

                               do{
                                   
                                   try collectionContacts.setData([
                                    "email": email,
                                    "name": name,
                                    "userId": uid,
             
                                   ]) { error in
                                       if error == nil{
                                           print("store success")
                                       }
                                   }
                                
                               }catch{
                                   print("Error adding document!")
                               }
                        self.setNameOfTheUserInFirebaseAuth(name: name)
                    }else{
                        //MARK: there is a error creating the user...
                        print(error)
                    }
                })
            }else{
                showAlertText(text: " please enter valid email. ")
            }
            //Validations....


        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
              
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
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
