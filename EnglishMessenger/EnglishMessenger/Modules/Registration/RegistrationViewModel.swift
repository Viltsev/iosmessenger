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
        input.firstNameSubject
            .combineLatest(input.lastNameSubject, input.emailSubject, input.passwordSubject)
            .map { [unowned self] _ in
                !self.output.firstNameFieldText.isEmpty
                && !self.output.lastNameFieldText.isEmpty
                && !self.output.emailFieldText.isEmpty
                && !self.output.passwordFieldText.isEmpty
            }
            .sink { isEnabled in
                self.output.isEnabledButton = !isEnabled
            }
            .store(in: &cancellable)
    }
    
    func registerUser() {
        input.registerUserSubject
            .sink { [weak self] in
                guard let firstName = self?.output.firstNameFieldText,
                      let lastName = self?.output.lastNameFieldText,
                      let email = self?.output.emailFieldText,
                      let password = self?.output.passwordFieldText else { return }
                
                self?.saveData(password, email)
                
                let userToRegistration = UserRegistration(firstName: firstName,
                                                          lastName: lastName,
                                                          email: email,
                                                          password: password)
                self?.apiService.registerUser(user: userToRegistration)
            }
            .store(in: &cancellable)
    }
    
    func saveData(_ password: String, _ email: String) {
        // remove current values
        UserDefaults.standard.removeObject(forKey: "email")
        
        // add new values
        UserDefaults.standard.setValue(email, forKey: "email")
        KeyChainStorage.saveStringToKeychain(string: password, forKey: email)
    }
}

extension RegistrationViewModel {
    struct Input {
        let firstNameSubject = PassthroughSubject<Void, Never>()
        let lastNameSubject = PassthroughSubject<Void, Never>()
        let emailSubject = PassthroughSubject<Void, Never>()
        let passwordSubject = PassthroughSubject<Void, Never>()
        let registerUserSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var firstNameFieldText: String = ""
        var lastNameFieldText: String = ""
        var emailFieldText: String = ""
        var passwordFieldText: String = ""
        var isEnabledButton: Bool = true
    }
}
