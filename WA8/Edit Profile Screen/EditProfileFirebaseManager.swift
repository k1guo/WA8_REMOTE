//
//  EditProfileFirebaseManager.swift
//  WA8
//
//  Created by 郭 on 2023/11/24.
//

import Foundation
extension EditProfileController{
    
    func uploadProfilePhoto(){
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
                                   if let newName = self.editScreen.textFieldName.text{
                                       self.setNameOfTheUserInFirebaseAuth(name:newName, photoURL: profilePhotoURL)
                                   }
                               }
                           })
                       }
                   })
               }
           }else{
               if let newName = self.editScreen.textFieldName.text{
                   setNameOfTheUserInFirebaseAuth(name:newName, photoURL: profilePhotoURL)
               }
           }
       }
    
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String, photoURL: URL?){
        let changeRequest = self.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        print("\(photoURL)")
        
//        showActivityIndicator()
        changeRequest?.commitChanges(completion: {(error) in
//            self.hideActivityIndicator()
            if error == nil{
                //MARK: the profile update is successful...
              
//                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
                self.showAlertText(text: String(describing: error))
            }
        })
    }

}
