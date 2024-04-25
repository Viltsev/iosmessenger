//
//  CardViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 23.04.2024.
//

import Foundation
import Combine

class CardViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension CardViewModel {
    func bind() {
        
    }
}

extension CardViewModel {
    struct Input {
        
    }
    
    struct Output {
        var cards: [ServerCard] = []
        var currentCount: Int = 1
    }
}
