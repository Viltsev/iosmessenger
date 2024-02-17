//
//  ProfileViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation
import Combine

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
        
    }
}

extension ProfileViewModel {
    struct Input {
        
    }
    
    struct Output {
        var username: String = "Danila Viltsev"
        var dateBirth: String = "24.12.2001"
        var languageLevel: String = "B2"
    }
}
