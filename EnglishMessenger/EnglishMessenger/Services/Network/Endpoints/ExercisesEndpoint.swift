//
//  ExercisesEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import Foundation
import Moya

enum ExercisesEndpoint {
    case getSentences(String)
    case getQuestion
    case sendAnswer(String, String)
}

extension ExercisesEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "http://127.0.0.1:8000")!
    }

    var path: String {
        switch self {
        case .getSentences:
            return "/get_sentence_exercise"
        case .getQuestion:
            return "/get_question"
        case .sendAnswer:
            return "/send_answer"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getSentences(let topic):
            return .requestParameters(parameters: ["topic": topic], encoding: URLEncoding.queryString)
        case .getQuestion:
            let level = UserDefaults.standard.string(forKey: "languageLevel")
            print("level = \(level ?? " empty level")")
            return .requestParameters(parameters: ["level": level ?? "B1"], encoding: URLEncoding.queryString)
        case .sendAnswer(let question, let answer):
            return .requestParameters(parameters: ["question": question, "answer": answer],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
