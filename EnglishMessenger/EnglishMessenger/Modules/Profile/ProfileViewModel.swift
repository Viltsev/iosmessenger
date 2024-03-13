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
    
    init() {
        bind()
    }
}

extension ProfileViewModel {
    func bind() {
        logout()
        
    }
    
    func logout() {
        input.logoutSubject
            .sink { router in
                AuthenticationService.shared.status.send(false)
                router.popToRoot()
            }
            .store(in: &cancellable)
    }
}

extension ProfileViewModel {
    struct Input {
        let logoutSubject = PassthroughSubject<StartNavigationRouter, Never>()
    }
    
    struct Output {
        var firstName: String = UserDefaults.standard.string(forKey: "firstName") ?? "First Name"
        var lastName: String = UserDefaults.standard.string(forKey: "lastName") ?? "Last Name"
        var username: String = UserDefaults.standard.string(forKey: "username") ?? "@username"
        var dateBirth: String = UserDefaults.standard.string(forKey: "dateOfBirth") ?? "DateOfBirth"
        var languageLevel: String = UserDefaults.standard.string(forKey: "languageLevel") ?? "Level not found"
        var photo: URL? = URL(string: UserDefaults.standard.string(forKey: "avatar") ?? "")
        // var photo: URL? = UserDefaults.standard.url(forKey: "avatar")
    }
}
