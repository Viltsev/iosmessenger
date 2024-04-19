//
//  ChatsStartViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 15.04.2024.
//

import Foundation
import Combine

class ChatsStartViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GenaralApi()
    
    init() {
        bind()
    }
}

extension ChatsStartViewModel {
    func bind() {
        findAllUsers()
        findUserByUsername()
        changeScreen()
        fetchAllChats()
    }
    
    func changeScreen() {
        input.changeCurrentScreenSubject
            .sink { [unowned self] screen in
                self.output.currentScreen = screen
            }
            .store(in: &cancellable)
    }
    
    func findUserByUsername() {
        let request = input.findUserByUsernameSubject
            .map { [unowned self] username in
                return self.apiService.getUserByUsername(username)
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink { error in
                print(error)
            }
            .store(in: &cancellable)
        
        request
            .values()
            .sink { [unowned self] user in
                self.output.findedUsers.insert(user, at: 0)
            }
            .store(in: &cancellable)
    }
    
    func findAllUsers() {
        let request = input.findAllUsersSubject
            .map { [unowned self] in
                return self.apiService.getAllUsers()
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink { error in
                print(error)
            }
            .store(in: &cancellable)
        
        request
            .values()
            .sink { [unowned self] users in
                self.output.mockUsers = users
            }
            .store(in: &cancellable)
    }
    
    func fetchAllChats() {
        let request = input.fetchAllChatsSubject
            .map { [unowned self] in
                return self.apiService.getChats()
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink { error in
                print(error)
            }
            .store(in: &cancellable)
        
        request
            .values()
            .sink { [unowned self] users in
                self.output.userChatsUsers = users.reversed()
                print("delete chat!")
            }
            .store(in: &cancellable)
    }
    
    func deleteChat(_ recipientEmail: String) {
        Task {
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            if let currentEmail = currentEmail {
                let chatId = generateChatId(senderId: currentEmail, recipientId: recipientEmail)
                do {
                    let response = try await apiService.deleteChat(chatId: chatId)
                    self.input.fetchAllChatsSubject.send()
                    print(response)
                } catch {
                    print("Network error!")
                }
            }
        }
    }
    
    func generateChatId(senderId: String, recipientId: String) -> String {
        let ids = [senderId, recipientId].sorted()
        return ids[0] + ids[1]
    }
}

extension ChatsStartViewModel {
    struct Input {
        let findAllUsersSubject = PassthroughSubject<Void, Never>()
        let findUserByUsernameSubject = PassthroughSubject<String, Never>()
        let changeCurrentScreenSubject = PassthroughSubject<CurrentScreen, Never>()
        let fetchAllChatsSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var findUserText = ""
        var userChatsUsers: [User] = []
        var findedUsers: [User] = []
        var mockUsers: [User] = []
        var currentScreen: CurrentScreen = .chats
        var deletedMessage: Bool = false
    }
}
