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
    
    init() {
        bind()
    }
}

extension FriendsViewModel {
    func bind() {
        changeScreen()
    }
    
    func changeScreen() {
        input.changeCurrentScreenSubject
            .sink { [unowned self] screen in
                self.output.state = screen
            }
            .store(in: &cancellable)
    }
}

extension FriendsViewModel {
    struct Input {
        let changeCurrentScreenSubject = PassthroughSubject<CurrentFriendScreen, Never>()
    }
    
    struct Output {
        var state: CurrentFriendScreen = .friends
        var searchedFriend: String = ""
    }
    
    enum CurrentFriendScreen {
        case search
        case friends
    }
}
