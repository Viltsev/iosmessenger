//
//  GeneralEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation
import Moya

enum RegistrationEndpoint {
    case registerUser(user: UserRegistration)
}

extension RegistrationEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .registerUser:
            return "/register"
        }
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
            switch self {
            case let .registerUser(user):
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
