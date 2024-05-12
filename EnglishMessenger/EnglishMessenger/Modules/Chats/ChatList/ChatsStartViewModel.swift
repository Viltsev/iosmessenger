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
    
    let apiService = GeneralApi()
    
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
        findCompanion()
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
    
    func findCompanion() {
        let request = input.findCompanionSubject
            .map { [unowned self] in
                return self.apiService.generateDialog()
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
            .sink { [unowned self] dialog in
                let isContains = self.output.userChatsUsers.contains { user in
                    user.email == dialog.email
                }
                if !isContains {
                    self.output.userChatsUsers.append(dialog)
                    self.output.userChatsUsers.reverse()
                }
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
    
    @MainActor
    func findLastMessage(_ recipientUser: User) {
        Task {
            let currentEmail = UserDefaults.standard.string(forKey: "email")
            if let currentEmail = currentEmail {
                let chatId = generateChatId(senderId: currentEmail, recipientId: recipientUser.email)
                do {
                    let response = try await apiService.getLastMessage(chatId: chatId)
                    if let index = self.output.userChatsUsers.firstIndex(where: { $0.id == recipientUser.id }) {
                        if response.contains("timestamp") {
                            self.output.userChatsUsers[index].lastMessage = ""
                        } else {
                            self.output.userChatsUsers[index].lastMessage = response
                        }
                    }
                    
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
        let findCompanionSubject = PassthroughSubject<Void, Never>()
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
