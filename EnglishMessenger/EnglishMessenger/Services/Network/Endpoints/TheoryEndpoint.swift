//
//  TheoryEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import Foundation
import Moya

enum TheoryEndpoint {
    case getTheory
}

extension TheoryEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .getTheory:
            return "/api/v1/theory/get_theory"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getTheory:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
