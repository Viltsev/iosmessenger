//
//  TheoryCardViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 29.04.2024.
//

import Foundation
import Combine

class TheoryCardViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension TheoryCardViewModel {
    func bind() {
        
    }
}

extension TheoryCardViewModel {
    struct Input {
        
    }
    
    struct Output {
        var theory: LocalTheoryList?
    }
}
