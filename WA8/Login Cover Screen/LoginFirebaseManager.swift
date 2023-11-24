//
//  RightBarButtonManager.swift
//  WA8
//
//  Created by 郭 on 2023/11/15.
//

import UIKit
import FirebaseAuth

extension ViewController{
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
