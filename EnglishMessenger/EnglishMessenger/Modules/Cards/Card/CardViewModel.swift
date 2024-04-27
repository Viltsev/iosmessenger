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
        getCardSet()
        continueLearning()
        againLearning()
    }
    
    func saveToLearned() {
        let request = input.saveToLearnedSubject
            .map { [unowned self] card in
                if let index = self.output.cards.firstIndex(where: { $0.id == card.id }) {
                    self.output.cards.remove(at: index)
                }
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
    
    func getCardSet() {
        let request = input.getCardSetSubject
            .map { [unowned self] id in
                return apiService.getCardSet(id: id)
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
            .sink { [unowned self] cardSet in
                self.output.cards = cardSet.toLearn
                self.output.cardsCount = cardSet.toLearn.count
                self.output.currentCount = 1
                if self.output.cards.isEmpty {
                    self.output.cardsCount = cardSet.cardList.count
                    self.output.state = .allLearned
                } else {
                    self.output.state = .process
                }
            }
            .store(in: &cancellable)
    }
    
    func continueLearning() {
        input.continueLearningSubject
            .sink { [unowned self] _ in
                self.output.currentCount = 1
                self.output.cardsCount = self.output.cards.count
                self.output.state = .process
            }
            .store(in: &cancellable)
    }
    
    func againLearning() {
        let request = input.learnAgainSubject
            .map { [unowned self] _ in
                return apiService.refreshCardsSet(id: self.output.setId)
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request.sink { [unowned self] _ in
            self.input.getCardSetSubject.send(self.output.setId)
        }
        .store(in: &cancellable)
    }
}

extension CardViewModel {
    struct Input {
        let saveToLearnedSubject = PassthroughSubject<LocalCard, Never>()
        let getCardSetSubject = PassthroughSubject<Int, Never>()
        let continueLearningSubject = PassthroughSubject<Void, Never>()
        let learnAgainSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var setId: Int = 0
        var cards: [LocalCard] = []
        var cardsCount = 0
        var currentCount: Int = 1
        var state: CardViewState = .process
    }
    
    enum CardViewState {
        case process
        case allLearned
        case notAllLearned
    }
}
