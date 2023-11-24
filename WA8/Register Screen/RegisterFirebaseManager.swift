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
    
    func uploadProfilePhotoToStorage(){
           var profilePhotoURL:URL?
           
           //MARK: Upload the profile photo if there is any...
           if let image = pickedImage{
               if let jpegData = image.jpegData(compressionQuality: 80){
                   let storageRef = storage.reference()
                   let imagesRepo = storageRef.child("imagesUsers")
                   let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                   
                   let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                       if error == nil{
                           imageRef.downloadURL(completion: {(url, error) in
                               if error == nil{
                                   profilePhotoURL = url
                                   self.registerNewAccount(photoURL: profilePhotoURL)
                               }
                           })
                       }
                   })
               }
           }else{
               registerNewAccount(photoURL: profilePhotoURL)
           }
       }
    
    func registerNewAccount(photoURL: URL?) {
        guard let name = registerScreen.textFieldName.text,
              let email = registerScreen.textFieldEmail.text,
              let password = registerScreen.textFieldPassword.text,
              let reEnterPassword = registerScreen.textFieldVerifyPassword.text else {
            return showAlertText(text: "Please fill in all fields.")
        }

        // 基本输入验证
        if name.isEmpty {
            return showAlertText(text: "Name is empty!")
        }
        if email.isEmpty {
            return showAlertText(text: "Email is empty!")
        }
        if !isValidEmail(email) {
            return showAlertText(text: "Please enter a valid email.")
        }
        if password.isEmpty {
            return showAlertText(text: "Password is empty!")
        }
        if password.count < 6 {
            return showAlertText(text: "The password should have at least 6 characters!")
        }
        if password != reEnterPassword {
            return showAlertText(text: "Passwords do not match!")
        }

        // Firebase 用户注册
        showActivityIndicator()
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.hideActivityIndicator()
            if let error = error {
                print(error)
                self.showAlertText(text: "This email address has been used or other error occurred!")
            } else if let uid = result?.user.uid {
                // 用户创建成功
                let contact = Contact(name: name, email: email, userId: uid)
                let collectionContacts = self.database.collection("users").document(name)
                do {
                    try collectionContacts.setData(["email": email, "name": name, "userId": uid]) { error in
                        if let error = error {
                            print(error)
                            self.showAlertText(text: "Error adding document!")
                        } else {
                            print("Store success")
                            self.showSuccessText(text: "Registration successful")
                            self.setNameOfTheUserInFirebaseAuth(name: name, photoURL: photoURL)
                        }
                    }
                } catch {
                    print("Error adding document!")
                    self.showAlertText(text: "Error adding document!")
                }
            }
        }
    }

    
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String,photoURL: URL?){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        print("\(photoURL)")
        
        showActivityIndicator()
        changeRequest?.commitChanges(completion: {(error) in
            self.hideActivityIndicator()
            if error == nil{
                //MARK: the profile update is successful...
              
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
                self.showAlertText(text: String(describing: error))
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
    
    func showSuccessText(text:String){
        let alert = UIAlertController(
            title: "Success",
            message: "\(text)",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

           
   
}
