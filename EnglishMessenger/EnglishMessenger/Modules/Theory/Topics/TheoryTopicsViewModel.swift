//
//  TheoryTopicsViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import Foundation
import Combine

class TheoryTopicsViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension TheoryTopicsViewModel {
    func bind() {
        
    }
}

extension TheoryTopicsViewModel {
    struct Input {
        
    }
    
    struct Output {
        var theory: LocalCategory?
    }
}
