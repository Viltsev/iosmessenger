//
//  OnboardingEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 10.03.2024.
//

import Foundation
import Moya

enum OnboardingEndpoint {
    case sendOnboardingData(onboarding: Onboarding)
}

extension OnboardingEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .sendOnboardingData:
            return "/api/v1/user/set_onboarding"
        }
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case let .sendOnboardingData(onboardingData):
            do {
                let jsonData = try JSONEncoder().encode(onboardingData)
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
