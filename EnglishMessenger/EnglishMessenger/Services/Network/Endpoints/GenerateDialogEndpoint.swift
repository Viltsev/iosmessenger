//
//  GenerateDialogEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 19.04.2024.
//

import Foundation
import Moya

enum GenerateDialogEndpoint {
    case generateDialog
}

extension GenerateDialogEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .generateDialog:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/dialog/generateDialog/\(currentEmail ?? "")"
        }
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case .generateDialog:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
