//
//  TestEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 04.03.2024.
//

import Foundation
import Moya

enum TestEndpoint {
    case fetchQuestions
}

extension TestEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .fetchQuestions:
            return "/api/v1/testing/fetchAllQuestions"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchQuestions:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
