//
//  GeneralAPI.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation
import Combine
import CombineMoya

struct GenaralApi {
    let provider = Provider<RegistrationEndpoint>()
}

extension GenaralApi {
    func registerUser(user: UserRegistration) {
        provider.request(.registerUser(user: user)) { result in
            switch result {
            case .success(let response):
                // Обработка успешного ответа
                print("Успешный ответ: \(response)")
            case .failure(let error):
                // Обработка ошибки
                print("Ошибка: \(error)")
            }
        }
    }
}
