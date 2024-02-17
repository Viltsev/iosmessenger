//
//  AuthorizationViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import Foundation
import Combine

class AuthorizationViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GenaralApi()
    
    init() {
        bind()
    }
}

extension AuthorizationViewModel {
    func bind() {
        authButtonEnable()
        authUser()
    }
    
    func authButtonEnable() {
        input.emailSubject
            .combineLatest(input.passwordSubject)
            .map { _ in
                !self.output.emailField.isEmpty && !self.output.passwordField.isEmpty
            }
            .sink { isEnabled in
                self.output.isEnabledButton = !isEnabled
            }
            .store(in: &cancellable)
    }
    
    func authUser() {
        input.authUserSubject
            .sink { [weak self] in
                guard let email = self?.output.emailField,
                      let password = self?.output.passwordField else { return }
                
                let userAuth = UserAuthorization(email: email, password: password)
                self?.apiService.authUser(user: userAuth)
            }
            .store(in: &cancellable)
    }
}

extension AuthorizationViewModel {
    struct Input {
        let emailSubject = PassthroughSubject<Void, Never>()
        let passwordSubject = PassthroughSubject<Void, Never>()
        let authUserSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var emailField = ""
        var passwordField = ""
        var isEnabledButton: Bool = true
    }
}
