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
    }
    
    func findAllUsers() {
        let request = input.findAllUsers
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
}

extension ChatsStartViewModel {
    struct Input {
        let findAllUsers = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var findUserText = ""
        var mockUsers: [User] = []
//        var mockUsers: [MockUser] = [
//            MockUser(username: "Kirill"),
//            MockUser(username: "Misha"),
//            MockUser(username: "Polina"),
//            MockUser(username: "Ksusha")
//        ]
    }
    
    struct MockUser {
        var id: UUID = UUID()
        let username: String
    }
}
