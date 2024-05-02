//
//  GeneralAPI.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation
import Combine
import CombineMoya

struct GeneralApi {
    let providerRegistration = Provider<RegistrationEndpoint>()
    let providerAuthorization = Provider<AuthorizationEndpoint>()
    let providerTesting = Provider<TestEndpoint>()
    let providerTestResults = Provider<TestResultsEndpoint>()
    let providerOnboardingData = Provider<OnboardingEndpoint>()
    let providerInterestsData = Provider<InterestsEndpoint>()
    let providerUsersData = Provider<UsersEndpoint>()
    let providerMessagesEndpoint = Provider<MessagesEndpoint>()
    let providerGrammarEndpoint = Provider<GrammarEndpoint>()
    let providerGenerateDialogEndpoint = Provider<GenerateDialogEndpoint>()
    let providerCardsEndpoint = Provider<CardsEndpoint>()
    let providerTheoryEndpoint = Provider<TheoryEndpoint>()
    let providerExercisesEndpoint = Provider<ExercisesEndpoint>()
}

extension GeneralApi {
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
    
    func getAllUsers() -> AnyPublisher<[User], ErrorAPI> {
        providerUsersData.requestPublisher(.getAllUsers)
            .filterSuccessfulStatusCodes()
            .map([ServerUser].self)
            .map { serverUsers in
                UserModelMapper().toLocal(list: serverUsers)
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
    
    func getChats() -> AnyPublisher<[User], ErrorAPI> {
        providerUsersData.requestPublisher(.getChatUser)
            .filterSuccessfulStatusCodes()
            .map([ServerUser].self)
            .map { serverUsers in
                UserModelMapper().toLocal(list: serverUsers)
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
    
    func getUserByUsername(_ username: String) -> AnyPublisher<User, ErrorAPI> {
        providerUsersData.requestPublisher(.getUserByUsername(username))
            .filterSuccessfulStatusCodes()
            .map(ServerUser.self)
            .map { serverUser in
                UserModelMapper().toLocal(serverEntity: serverUser)
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
    
    
    func getAllMessages(chatId: String) async throws -> [Message] {
        return try await withCheckedThrowingContinuation { continuation in
            providerMessagesEndpoint.request(.getAllChatMessages(chatId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let serverMessages = try JSONDecoder().decode([Message].self, from: response.data)
                        continuation.resume(returning: serverMessages)
                    } catch {
                        if response.statusCode == 404 {
                            continuation.resume(throwing: ErrorAPI.notFound)
                        } else {
                            continuation.resume(throwing: ErrorAPI.network)
                        }
                    }
                case .failure:
                    continuation.resume(throwing: ErrorAPI.network)
                }
            }
        }
    }
    
    func checkGrammar(text: String) -> AnyPublisher<[LocalGrammar], ErrorAPI> {
        providerGrammarEndpoint.requestPublisher(.checkGrammar(text))
            .filterSuccessfulStatusCodes()
            .map([ServerGrammar].self)
            .map { serverGrammar in
                GrammarModelMapper().toLocal(list: serverGrammar)
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
    
    func deleteChat(chatId: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            providerUsersData.request(.deleteChat(chatId)) { result in
                switch result {
                case .success(let response):
                    guard let serverResponse = String(data: response.data, encoding: .utf8) else {
                        if response.statusCode == 404 {
                            return continuation.resume(throwing: ErrorAPI.notFound)
                        } else {
                            return continuation.resume(throwing: ErrorAPI.network)
                        }
                    }
                    continuation.resume(returning: serverResponse)
                case .failure:
                    continuation.resume(throwing: ErrorAPI.network)
                }
            }
        }
    }
    
    func generateDialog() -> AnyPublisher<User, ErrorAPI> {
        providerGenerateDialogEndpoint.requestPublisher(.generateDialog)
            .filterSuccessfulStatusCodes()
            .map(ServerUser.self)
            .map { serverUser in
                UserModelMapper().toLocal(serverEntity: serverUser)
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
    
    func getToLearnCards() -> AnyPublisher<[LocalCard], ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.getAllToLearn)
            .filterSuccessfulStatusCodes()
            .map([ServerCard].self)
            .map { serverCards in
                CardModelMapper().toLocal(list: serverCards)
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
    
    func getLearnedCards() -> AnyPublisher<[LocalCard], ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.getAllLearned)
            .filterSuccessfulStatusCodes()
            .map([ServerCard].self)
            .map { serverCards in
                CardModelMapper().toLocal(list: serverCards)
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
    
    func getCardSets() -> AnyPublisher<[LocalCardSet], ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.getCardSets)
            .filterSuccessfulStatusCodes()
            .map([ServerCardSet].self)
            .map { serverCardSets in
                CardSetModelMapper().toLocal(list: serverCardSets)
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
    
    func createSet(set: CreateSet) -> AnyPublisher<String, ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.createSet(set))
            .filterSuccessfulStatusCodes()
            .map(String.self)
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
    
    func createCard(card: CreateCard) -> AnyPublisher<String, ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.createCard(card))
            .filterSuccessfulStatusCodes()
            .map(String.self)
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
    
    func saveToLearned(card: LocalCard) -> AnyPublisher<String, ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.saveToLearned(card))
            .filterSuccessfulStatusCodes()
            .map(String.self)
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
    
    func getCardSet(id: Int) -> AnyPublisher<LocalCardSet, ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.getCardSet(id))
            .filterSuccessfulStatusCodes()
            .map(ServerCardSet.self)
            .map { serverCardSet in
                CardSetModelMapper().toLocal(serverEntity: serverCardSet)
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
    
    func refreshCardsSet(id: Int) -> AnyPublisher<String, ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.refreshCards(id))
            .filterSuccessfulStatusCodes()
            .map(String.self)
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
    
    func deleteCard(card: LocalCard) -> AnyPublisher<String, ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.deleteCard(card))
            .filterSuccessfulStatusCodes()
            .map(String.self)
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
    
    func deleteSet(id: Int) -> AnyPublisher<String, ErrorAPI> {
        providerCardsEndpoint.requestPublisher(.deleteSet(id))
            .filterSuccessfulStatusCodes()
            .map(String.self)
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
    
    func getTheory() -> AnyPublisher<LocalTheory, ErrorAPI> {
        providerTheoryEndpoint.requestPublisher(.getTheory)
            .filterSuccessfulStatusCodes()
            .map(ServerTheory.self)
            .map { serverTheory in
                TheoryModelMapper().toLocal(serverEntity: serverTheory)
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
    
    func getTrainSentences(topic: String) -> AnyPublisher<[LocalTraining], ErrorAPI> {
        providerExercisesEndpoint.requestPublisher(.getSentences(topic))
            .filterSuccessfulStatusCodes()
            .map([ServerTraining].self)
            .map { serverTraining in
                ExerciseTrainingModelMapper().toLocal(list: serverTraining)
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
