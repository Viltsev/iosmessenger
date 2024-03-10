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
    
//    func loadImage() {
//        guard let data = self.output.photoData else { return }
//
//        guard let uiImage = UIImage(data: data) else { return }
//        self.output.photo = uiImage
//    }
    
    func logout() {
        input.logoutSubject
            .sink {
                AuthenticationService.shared.status.send(false)
            }
            .store(in: &cancellable)
    }
}

extension ProfileViewModel {
    struct Input {
        let logoutSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var firstName: String = UserDefaults.standard.string(forKey: "firstName") ?? "First Name"
        var lastName: String = UserDefaults.standard.string(forKey: "lastName") ?? "Last Name"
        var username: String = UserDefaults.standard.string(forKey: "username") ?? "@username"
        var dateBirth: String = UserDefaults.standard.string(forKey: "dateOfBirth") ?? "DateOfBirth"
        var languageLevel: String = UserDefaults.standard.string(forKey: "languageLevel") ?? "Level not found"
        // todo: add photo
//        var photoData: Data? = UserDefaults.standard.data(forKey: "photo")
//        var photo: UIImage = UIImage(named: "default")!
    }
}
