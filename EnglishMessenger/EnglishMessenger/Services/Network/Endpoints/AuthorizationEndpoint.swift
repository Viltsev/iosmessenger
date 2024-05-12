//
//  AuthorizationEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation
import Moya

enum AuthorizationEndpoint {
    case authUser(user: UserAuthorization)
}

extension AuthorizationEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .authUser:
            return "/auth"
        }
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case let .authUser(user):
            do {
                let jsonData = try JSONEncoder().encode(user)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON для отправки: \(jsonString)")
                } else {
                    print("Невозможно преобразовать JSON данные в строку.")
                }
                return .requestData(jsonData)
            } catch {
                fatalError("Unable to encode parameters: \(error)")
            }
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
