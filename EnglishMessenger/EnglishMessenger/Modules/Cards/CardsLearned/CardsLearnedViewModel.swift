//
//  CardsLearnedViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 24.04.2024.
//

import Foundation
import Combine

class CardsLearnedViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension CardsLearnedViewModel {
    func bind() {
        getAllLearnedCards()
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
                self.output.learnedCards.append(contentsOf: cards)
                if !self.output.learnedCards.isEmpty {
                    self.output.viewState = .hasWords
                } else {
                    self.output.viewState = .nothingWords
                }
            }
            .store(in: &cancellable)
    }
}

extension CardsLearnedViewModel {
    struct Input {
        let getLearnedCardsSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var learnedCards: [LocalCard] = []
        var viewState: ViewState = .nothingWords
    }
    
    enum ViewState {
        case nothingWords
        case hasWords
    }
}

