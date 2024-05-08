//
//  TestResultsEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 05.03.2024.
//

import Foundation
import Moya

enum TestResultsEndpoint {
    case getResults(answerList: [Answer])
}

extension TestResultsEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8080")!
    }
    
    var path: String {
        switch self {
        case .getResults:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/testing/getCurrentLevel/\(currentEmail ?? "")"
        }
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case let .getResults(answerList):
            do {
                let jsonData = try JSONEncoder().encode(answerList)
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
