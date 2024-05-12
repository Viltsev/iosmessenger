//
//  GrammarEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 18.04.2024.
//

import Foundation
import Moya

enum GrammarEndpoint {
    case checkGrammar(String)
}

extension GrammarEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .checkGrammar:
            return "/api/v1/checkGrammar"
        }
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case .checkGrammar(let text):
            do {
                let jsonData = try JSONEncoder().encode(text)
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
