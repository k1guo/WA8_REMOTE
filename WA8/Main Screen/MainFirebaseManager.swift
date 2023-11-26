//
//  MainFirebaseStorageManager.swift
//  WA8
//
//  Created by 郭 on 2023/11/26.
//

import Foundation
import FirebaseStorage
import UIKit


extension MainViewController{
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
    
}
