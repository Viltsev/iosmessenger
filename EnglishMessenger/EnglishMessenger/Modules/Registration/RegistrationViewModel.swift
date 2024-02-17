//
//  RegistrationViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
}

extension RegistrationViewModel {
    func bind() {
        registration()
    }
    
    func registration() {
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
}

extension RegistrationViewModel {
    struct Input {
        let usernameSubject = PassthroughSubject<Void, Never>()
        let emailSubject = PassthroughSubject<Void, Never>()
        let passwordSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var userNameFieldText: String = ""
        var emailFieldText: String = ""
        var passwordFieldText: String = ""
        var isEnabledButton: Bool = true
    }
}
