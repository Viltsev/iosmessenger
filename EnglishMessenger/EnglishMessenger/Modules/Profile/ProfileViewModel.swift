//
//  ProfileViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation
import Combine
import SwiftUI

class ProfileViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension ProfileViewModel {
    func bind() {
        logout()
        friendsCount()
    }
    
    func logout() {
        input.logoutSubject
            .sink { router in
                AuthenticationService.shared.status.send(false)
                router.popToRoot()
            }
            .store(in: &cancellable)
    }
    
    func friendsCount() {
        let request = input.friendsCountSubject
            .map { [unowned self] _ in
                return self.apiService.getFriendsCount()
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
            .sink { [unowned self] count in
                self.output.friendsCount = count
            }
            .store(in: &cancellable)
    }
}

extension ProfileViewModel {
    struct Input {
        let logoutSubject = PassthroughSubject<StartNavigationRouter, Never>()
        let friendsCountSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var firstName: String = UserDefaults.standard.string(forKey: "firstName") ?? "First Name"
        var lastName: String = UserDefaults.standard.string(forKey: "lastName") ?? "Last Name"
        var username: String = UserDefaults.standard.string(forKey: "username") ?? "@username"
        var dateBirth: String = UserDefaults.standard.string(forKey: "dateOfBirth") ?? "DateOfBirth"
        var languageLevel: String = UserDefaults.standard.string(forKey: "languageLevel") ?? "Level not found"
        var photo: URL? = URL(string: UserDefaults.standard.string(forKey: "avatar") ?? "")
        var friendsCount: Int = UserDefaults.standard.integer(forKey: "friendsCount")
    }
}
