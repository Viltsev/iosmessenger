//
//  RegistrationViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import Foundation
import Combine
import Moya

class RegistrationViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GenaralApi()
    
    init() {
        bind()
    }
    
}

extension RegistrationViewModel {
    func bind() {
        registrationButtonEnable()
        registerUser()
    }
    
    func registrationButtonEnable() {
        input.usernameSubject
            .combineLatest(input.emailSubject, input.passwordSubject)
            .map {_ in 
                !self.output.userNameFieldText.isEmpty && !self.output.emailFieldText.isEmpty && !self.output.passwordFieldText.isEmpty
            }
            .sink { isEnabled in
                self.output.isEnabledButton = !isEnabled
            }
            .store(in: &cancellable)
    }
    
    func registerUser() {
        input.registerUserSubject
            .sink { [weak self] in
                guard let username = self?.output.userNameFieldText,
                      let email = self?.output.emailFieldText,
                      let password = self?.output.passwordFieldText else { return }
                
                let userToRegistration = UserRegistration(username: username,
                                                      email: email,
                                                      password: password)
                self?.apiService.registerUser(user: userToRegistration)
            }
            .store(in: &cancellable)
    }
}

extension RegistrationViewModel {
    struct Input {
        let usernameSubject = PassthroughSubject<Void, Never>()
        let emailSubject = PassthroughSubject<Void, Never>()
        let passwordSubject = PassthroughSubject<Void, Never>()
        let registerUserSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var userNameFieldText: String = ""
        var emailFieldText: String = ""
        var passwordFieldText: String = ""
        var isEnabledButton: Bool = true
    }
}
