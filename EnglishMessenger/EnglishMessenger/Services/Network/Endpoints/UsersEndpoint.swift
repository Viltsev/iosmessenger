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
}

extension UsersEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "http://localhost:8080")!
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
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
