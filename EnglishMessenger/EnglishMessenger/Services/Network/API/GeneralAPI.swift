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
    let providerTesting = Provider<TestEndpoint>()
}

extension GenaralApi {
    func registerUser(user: UserRegistration) {
        providerRegistration.request(.registerUser(user: user)) { result in
            switch result {
            case .success(let response):
                print("Успешный ответ: \(response)")
                AuthenticationService.shared.status.send(true)
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        }
    }
    
    func authUser(user: UserAuthorization) -> AnyPublisher<User, ErrorAPI> {
        providerAuthorization.requestPublisher(.authUser(user: user))
            .filterSuccessfulStatusCodes()
            .map(ServerUser.self)
            .map {
                UserModelMapper().toLocal(serverEntity: $0)
            }
            .mapError { error in
                if error.response?.statusCode == 404 {
                    return ErrorAPI.notFound
                } else {
                    return ErrorAPI.network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTestData() -> AnyPublisher<[LocalTest], ErrorAPI> {
        providerTesting.requestPublisher(.fetchQuestions)
            .filterSuccessfulStatusCodes()
            .map([ServerTest].self)
            .map { serverTests in
                TestModelMapper().toLocal(list: serverTests)
            }
            .mapError { error in
                if error.response?.statusCode == 404 {
                    return ErrorAPI.notFound
                } else {
                    return ErrorAPI.network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
