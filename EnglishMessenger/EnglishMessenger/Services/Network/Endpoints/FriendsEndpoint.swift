//
//  FriendsEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 12.05.2024.
//

import Foundation
import Moya

enum FriendsEndpoint {
    case getFriends
    case getRequests
    case addFriendRequest(String)
    case acceptRequest(String)
    case rejectRequest(String)
    case getFriendsCount
}

extension FriendsEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .getFriends:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/user/get_friends/\(currentEmail ?? "")"
        case .getRequests:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/friends/get_friends_requests/\(currentEmail ?? "")"
        case .addFriendRequest:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/friends/addingFriend/\(currentEmail ?? "")"
        case .acceptRequest:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/friends/addingFriend/accepted/\(currentEmail ?? "")"
        case .rejectRequest:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/friends/addingFriend/rejected/\(currentEmail ?? "")"
        case .getFriendsCount:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/friends/getFriends/\(currentEmail ?? "")"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFriends:
                .get
        case .getRequests:
                .get
        case .addFriendRequest:
                .get
        case .acceptRequest:
                .post
        case .rejectRequest:
                .post
        case .getFriendsCount:
                .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getFriends:
            return .requestPlain
        case .getRequests:
            return .requestPlain
        case .addFriendRequest(let requestEmail):
            return .requestParameters(parameters: ["requestedEmail": requestEmail],
                                      encoding: URLEncoding.queryString)
        case .acceptRequest(let senderEmail):
            return .requestParameters(parameters: ["sentEmail": senderEmail],
                                      encoding: URLEncoding.queryString)
        case .rejectRequest(let senderEmail):
            return .requestParameters(parameters: ["sentEmail": senderEmail],
                                      encoding: URLEncoding.queryString)
        case .getFriendsCount:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
