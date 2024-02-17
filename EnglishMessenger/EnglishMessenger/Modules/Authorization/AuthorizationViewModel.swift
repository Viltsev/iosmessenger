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
    
    init() {
        bind()
    }
}

extension AuthorizationViewModel {
    func bind() {
        auth()
    }
    
    func auth() {
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
}

extension AuthorizationViewModel {
    struct Input {
        let emailSubject = PassthroughSubject<Void, Never>()
        let passwordSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var emailField = ""
        var passwordField = ""
        var isEnabledButton: Bool = true
    }
}
