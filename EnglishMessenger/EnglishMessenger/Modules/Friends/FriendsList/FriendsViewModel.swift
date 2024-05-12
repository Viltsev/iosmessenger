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
}

extension FriendsViewModel {
    struct Input {
        let changeCurrentScreenSubject = PassthroughSubject<CurrentFriendScreen, Never>()
        let findUserByUsernameSubject = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var state: CurrentFriendScreen = .friends
        var searchedFriend: String = ""
        var findedUsers: [User] = []
    }
    
    enum CurrentFriendScreen {
        case search
        case friends
    }
}
