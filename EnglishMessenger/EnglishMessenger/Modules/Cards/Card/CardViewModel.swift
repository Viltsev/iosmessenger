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
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension CardViewModel {
    func bind() {
        saveToLearned()
    }
    
    func saveToLearned() {
        let request = input.saveToLearnedSubject
            .map { [unowned self] card in
                return apiService.saveToLearned(card: card)
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink {
                error in
                print(error)
            }
            .store(in: &cancellable)
        
        request
            .values()
            .sink { string in
                print(string)
            }
            .store(in: &cancellable)
    }
}

extension CardViewModel {
    struct Input {
        let saveToLearnedSubject = PassthroughSubject<LocalCard, Never>()
    }
    
    struct Output {
        var cards: [LocalCard] = []
        var currentCount: Int = 1
    }
}
