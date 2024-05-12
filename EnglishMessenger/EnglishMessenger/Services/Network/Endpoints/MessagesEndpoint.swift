//
//  MessagesEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 16.04.2024.
//

import Foundation
import Moya

enum MessagesEndpoint {
    case getAllChatMessages(String)
}

extension MessagesEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .getAllChatMessages(let chatId):
            return "/api/v1/users/get_chat_messages/\(chatId)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllChatMessages:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
