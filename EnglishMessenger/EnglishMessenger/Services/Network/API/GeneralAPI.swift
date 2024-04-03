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
    let providerTestResults = Provider<TestResultsEndpoint>()
    let providerOnboardingData = Provider<OnboardingEndpoint>()
    let providerInterestsData = Provider<InterestsEndpoint>()
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
    
    func getCurrentLevel(answerList: [Answer]) -> AnyPublisher<String, ErrorAPI> {
        providerTestResults.requestPublisher(.getResults(answerList: answerList))
            .filterSuccessfulStatusCodes()
            .tryMap({ response in
                guard let level = String(data: response.data, encoding: .utf8) else {
                    throw ErrorAPI.network
                }
                return level
            })
            .mapError { error in
                if let error = error as? ErrorAPI {
                    return error
                } else {
                    return ErrorAPI.network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func sendOnboardingData(onboardingData: Onboarding) {
        providerOnboardingData.request(.sendOnboardingData(onboarding: onboardingData)) { result in
            switch result {
            case .success(let response):
                print("Успешный ответ: \(response)")
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        }
    }
    
    func fetchInterestsList() -> AnyPublisher<[LocalInterests], ErrorAPI> {
        providerInterestsData.requestPublisher(.getListInterests)
            .filterSuccessfulStatusCodes()
            .map([ServerInterests].self)
            .map { serverInterests in
                InterestsModelMapper().toLocal(list: serverInterests)
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
    
    func sendInterestsList(interestsIds: [Int]) {
        providerInterestsData.request(.sendInterestIds(interestIdList: interestsIds)) { result in
            switch result {
            case .success(let response):
                print("Успешный ответ: \(response)")
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        }
    }
}
