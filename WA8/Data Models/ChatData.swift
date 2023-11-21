//
//  ChatData.swift
//  WA8
//
//  Created by 郭 on 2023/11/18.
//

import Foundation

struct ChatMessage: Codable {
    var senderId: String
    var message: String
    var timestamp: Date

}


