//
//  AuthorizationViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import Foundation
import Combine
import CombineExt
import UIKit
import SwiftUI

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
        let request = input.authUserSubject
            .map { [unowned self] in
                let userAuth = UserAuthorization(email: self.output.emailField, password: self.output.passwordField)
                return self.apiService.authUser(user: userAuth)
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
            .sink { [unowned self] user in
                self.saveToUserDefaults(user: user)
                AuthenticationService.shared.status.send(true)
            }
            .store(in: &cancellable)
    }
    
    func saveToUserDefaults(user: User) {
        // todo: add photo
        
        // delete current values from UserDefaults
        UserDefaults.standard.removeObject(forKey: "dateOfBirth")
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "languageLevel")
        
        // add new values to UserDefaults
        UserDefaults.standard.setValue(user.firstName, forKey: "firstName")
        UserDefaults.standard.setValue(user.lastName, forKey: "lastName")
        UserDefaults.standard.setValue(user.username, forKey: "username")
        UserDefaults.standard.setValue(user.languageLevel, forKey: "languageLevel")
        formatDate(dateOfBirth: user.dateOfBirth)
    }
    
    func formatDate(dateOfBirth: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateOfBirth
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            let formattedDateString = dateFormatter.string(from: date)
            UserDefaults.standard.setValue(formattedDateString, forKey: "dateOfBirth")
        } else {
            print("Невозможно преобразовать строку в дату")
        }
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
        var user: User?
    }
}
