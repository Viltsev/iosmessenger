//
//  CardsEndpoint.swift
//  EnglishMessenger
//
//  Created by Данила on 24.04.2024.
//

import Foundation
import Moya

enum CardsEndpoint {
    case getAllToLearn
    case getAllLearned
    case getCardSets
    case createSet(CreateSet)
    case createCard(CreateCard)
    case saveToLearned(LocalCard)
    case getCardSet(Int)
    case refreshCards(Int)
    case deleteCard(LocalCard)
    case deleteSet(Int)
}

extension CardsEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .getAllToLearn:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/cards/get_all_to_learn/\(currentEmail ?? "")"
        case .getAllLearned:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/cards/get_all_learned/\(currentEmail ?? "")"
        case .getCardSets:
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/cards/get_all_card_sets/\(currentEmail ?? "")"
        case .createSet:
            return "/api/v1/cards/createCardSet"
        case .createCard:
            return "/api/v1/cards/createCard"
        case .saveToLearned:
            return "/api/v1/cards/save_to_learned"
        case .getCardSet(let id):
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/cards/get_card_set/\(currentEmail ?? "")/\(id)"
        case .refreshCards(let id):
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/cards/refresh_set/\(id)/\(currentEmail ?? "")"
        case .deleteCard:
            return "/api/v1/cards/delete_card"
        case .deleteSet(let id):
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            return "/api/v1/cards/delete_set/\(id)/\(currentEmail ?? "")"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllLearned:
            return .get
        case .getAllToLearn:
            return .get
        case .getCardSets:
            return .get
        case .createSet:
            return .post
        case .createCard:
            return .post
        case .saveToLearned:
            return .post
        case .getCardSet:
            return .get
        case .refreshCards:
            return .post
        case .deleteCard:
            return .delete
        case .deleteSet:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllToLearn:
            return .requestPlain
        case .getAllLearned:
            return .requestPlain
        case .getCardSets:
            return .requestPlain
        case .createSet(let set):
            do {
                let jsonData = try JSONEncoder().encode(set)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON для отправки: \(jsonString)")
                } else {
                    print("Невозможно преобразовать JSON данные в строку.")
                }
                return .requestData(jsonData)
            } catch {
                fatalError("Unable to encode parameters: \(error)")
            }
        case .createCard(let card):
            do {
                let jsonData = try JSONEncoder().encode(card)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON для отправки: \(jsonString)")
                } else {
                    print("Невозможно преобразовать JSON данные в строку.")
                }
                return .requestData(jsonData)
            } catch {
                fatalError("Unable to encode parameters: \(error)")
            }
        case .saveToLearned(let card):
            do {
                let jsonData = try JSONEncoder().encode(card)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON для отправки: \(jsonString)")
                } else {
                    print("Невозможно преобразовать JSON данные в строку.")
                }
                return .requestData(jsonData)
            } catch {
                fatalError("Unable to encode parameters: \(error)")
            }
        case .getCardSet:
            return .requestPlain
        case .refreshCards:
            return .requestPlain
        case .deleteCard(let card):
            do {
                let jsonData = try JSONEncoder().encode(card)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON для отправки: \(jsonString)")
                } else {
                    print("Невозможно преобразовать JSON данные в строку.")
                }
                return .requestData(jsonData)
            } catch {
                fatalError("Unable to encode parameters: \(error)")
            }
        case .deleteSet:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
