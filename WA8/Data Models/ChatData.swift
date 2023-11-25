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

struct ChatImage: Codable {
    var senderId: String
    var imageUrl: URL
    var timestamp: Date
}

enum ChatSessionContent: Codable{
    case message(ChatMessage)
    case image(ChatImage)
    var timestamp: Date {
        switch self {
        case .message(let message):
            return message.timestamp
        case .image(let image):
            return image.timestamp
        }
    }
}
