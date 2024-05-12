//
//  FriendsViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 12.05.2024.
//

import Foundation
import Combine

class FriendsViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension FriendsViewModel {
    func bind() {
        changeScreen()
        findUserByUsername()
        getFriends()
        addingFriend()
        addingFriendView()
    }
    
    func changeScreen() {
        input.changeCurrentScreenSubject
            .sink { [unowned self] screen in
                self.output.state = screen
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
    
    func getFriends() {
        let request = input.getFriendsSubject
            .map { [unowned self] _ in
                return self.apiService.getFriends()
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
            .sink { [unowned self] friends in
                self.output.friendsList = friends.reversed()
            }
            .store(in: &cancellable)
    }
    
    func addingFriend() {
        let request = input.addingFriendSubject
            .map { [unowned self] email in
                return self.apiService.addingFriend(email: email)
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
            .sink { message in
                print(message)
            }
            .store(in: &cancellable)
    }
    
    func addingFriendView() {
        input.addingFriendViewSubject
            .sink { [unowned self] id in
                if let index = self.output.findedUsers.firstIndex(where: { $0.id == id }) {
                    self.output.findedUsers[index].isRequested = true
                }
            }
            .store(in: &cancellable)
    }
}

extension FriendsViewModel {
    struct Input {
        let changeCurrentScreenSubject = PassthroughSubject<CurrentFriendScreen, Never>()
        let findUserByUsernameSubject = PassthroughSubject<String, Never>()
        let getFriendsSubject = PassthroughSubject<Void, Never>()
        let addingFriendSubject = PassthroughSubject<String, Never>()
        let addingFriendViewSubject = PassthroughSubject<UUID, Never>()
    }
    
    struct Output {
        var state: CurrentFriendScreen = .friends
        var searchedFriend: String = ""
        var friendsList: [User] = []
        var findedUsers: [User] = []
    }
    
    enum CurrentFriendScreen {
        case search
        case friends
    }
}
