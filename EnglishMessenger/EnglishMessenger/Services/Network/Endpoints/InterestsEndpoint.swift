//
//  InterestsEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 03.04.2024.
//

import Foundation
import Moya

enum InterestsEndpoint {
    case getListInterests
    case sendInterestIds(interestIdList: [Int])
}

extension InterestsEndpoint: TargetType {
    var baseURL: URL {
//        URL(string: "http://localhost:8080")!
        URL(string: "http://90.156.224.51:8081")!
    }
    
    var path: String {
        switch self {
        case .getListInterests:
            return "/interests/getAll"
        case .sendInterestIds:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/interests/save/\(currentEmail ?? "")"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListInterests:
                .get
        case .sendInterestIds:
                .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getListInterests:
            return .requestPlain
        case .sendInterestIds(let interestsIds):
            do {
                let jsonData = try JSONEncoder().encode(interestsIds)
                
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
