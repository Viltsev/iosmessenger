//
//  AuthenticationService.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation
import Combine

final class AuthenticationService {
    let status = CurrentValueSubject<Bool, Never>(UserStorage.shared.authStatus)
    static var shared = AuthenticationService()
    var cancellable = Set<AnyCancellable>()
    
    private init() {
        status
            .sink { value in
                UserStorage.shared.authStatus = value
            }
            .store(in: &cancellable)
    }
}
