//
//  DictionaryEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 03.05.2024.
//

import Foundation
import Moya

enum DictionaryEndpoint {
    case getRussianTranslation(String)
    case getEnglishTranslation(String)
}

extension DictionaryEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .getRussianTranslation:
            return "/dictionary/findEngWord"
        case .getEnglishTranslation:
            return "/dictionary/findRusWord"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getRussianTranslation(let word):
            return .requestParameters(parameters: ["searchWord": word], encoding: URLEncoding.queryString)
        case .getEnglishTranslation(let word):
            return .requestParameters(parameters: ["searchWord": word], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
