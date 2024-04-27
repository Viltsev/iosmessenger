//
//  CardsViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 24.04.2024.
//

import Foundation
import Combine

class CardsViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension CardsViewModel {
    func bind() {
        getAllLearnedCards()
        getAllToLearnCards()
    }
    
    func getAllLearnedCards() {
        let request = input.getLearnedCardsSubject
            .map { [unowned self] in
                return apiService.getLearnedCards()
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
            .sink { [unowned self] cards in
                self.output.learnedCards = cards
            }
            .store(in: &cancellable)
    }
    
    func getAllToLearnCards() {
        let request = input.getToLearnCardsSubject
            .map { [unowned self] in
                return apiService.getToLearnCards()
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
            .sink { [unowned self] cards in
                self.output.toLearnCards = cards
            }
            .store(in: &cancellable)
    }
}

extension CardsViewModel {
    struct Input {
        let getLearnedCardsSubject = PassthroughSubject<Void, Never>()
        let getToLearnCardsSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var toLearnCards: [LocalCard] = []
        var learnedCards: [LocalCard] = []
    }
}
