//
//  FriendRequestsViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 12.05.2024.
//

import Foundation
import Combine

class FriendRequestsViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension FriendRequestsViewModel {
    func bind() {
        getRequests()
        acceptRequest()
        rejectRequest()
        deleteRequest()
    }
    
    func getRequests() {
        let request = input.getRequestsSubject
            .map { [unowned self] _ in
                return self.apiService.getFriendsRequests()
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink { error in
                print(error)
                self.output.state = .empty
            }
            .store(in: &cancellable)
        
        request
            .values()
            .sink { [unowned self] requests in
                self.output.requestsList = requests
                self.output.state = .users
            }
            .store(in: &cancellable)
    }
    
    func acceptRequest() {
        let request = input.acceptRequestSubject
            .map { [unowned self] email in
                return self.apiService.acceptRequest(email: email)
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
    
    func rejectRequest() {
        let request = input.rejectRequestSubject
            .map { [unowned self] email in
                return self.apiService.rejectRequest(email: email)
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
    
    func deleteRequest() {
        input.deleteRequestSubject
            .sink { [unowned self] id in
                if let index = self.output.requestsList.firstIndex(where: { $0.id == id }) {
                    self.output.requestsList.remove(at: index)
                }
            }
            .store(in: &cancellable)
    }
}

extension FriendRequestsViewModel {
    struct Input {
        let getRequestsSubject = PassthroughSubject<Void, Never>()
        let acceptRequestSubject = PassthroughSubject<String, Never>()
        let rejectRequestSubject = PassthroughSubject<String, Never>()
        let deleteRequestSubject = PassthroughSubject<UUID, Never>()
    }
    
    struct Output {
        var requestsList: [User] = []
        var state: CurrentRequestScreen = .empty
    }
    
    enum CurrentRequestScreen {
        case users
        case empty
    }
}
