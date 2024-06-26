//
//  GetAllUsersEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 15.04.2024.
//

import Foundation
import Moya

enum UsersEndpoint {
    case getAllUsers
    case getUserByUsername(String)
    case getChatUser
    case deleteChat(String)
    case getLastMessage(String)
}

extension UsersEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .getAllUsers:
            return "/api/v1/user/get_all_users"
        case .getUserByUsername(let username):
            return "/api/v1/user/get_user_by_username/\(username)"
        case .getChatUser:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/users/fetch_all_chat_users/\(currentEmail ?? "")"
        case .deleteChat(let chatId):
            return "/api/v1/users/delete_chat/\(chatId)"
        case .getLastMessage(let chatId):
            return "/api/v1/users/get_last_message/\(chatId)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllUsers:
            return .requestPlain
        case .getUserByUsername:
            return .requestPlain
        case .getChatUser:
            return .requestPlain
        case .deleteChat:
            return .requestPlain
        case .getLastMessage:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
