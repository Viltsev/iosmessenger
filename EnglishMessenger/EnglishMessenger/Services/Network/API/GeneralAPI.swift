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
    let providerRegistration = Provider<RegistrationEndpoint>()
    let providerAuthorization = Provider<AuthorizationEndpoint>()
}

extension GenaralApi {
    func registerUser(user: UserRegistration) {
        providerRegistration.request(.registerUser(user: user)) { result in
            switch result {
            case .success(let response):
                print("Успешный ответ: \(response)")
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        }
    }
    
    func authUser(user: UserAuthorization) {
        providerAuthorization.request(.authUser(user: user)) { result in
            switch result {
            case .success(let response):
                print("Успешный ответ: \(response)")
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        }
    }
    
}
