//
//  Contact.swift
//  WA8
//
//  Created by 郭 on 2023/11/15.
//

import Foundation
import FirebaseFirestoreSwift

struct Contact: Codable{
    @DocumentID var id: String?
    var name: String
    var email: String
    var userId:String
    
    
    init(name: String, email: String, userId:String) {
        self.name = name
        self.email = email
        self.userId = userId
    }
}
