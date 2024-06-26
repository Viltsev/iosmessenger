//
//  CardsLearningViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 24.04.2024.
//

import Foundation
import Combine

class CardsLearningViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension CardsLearningViewModel {
    func bind() {
        getAllToLearnCards()
        createWordButtonEnable()
        getCardSets()
        chooseSet()
        createCard()
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
                self.output.toLearnCards.reverse()
                self.output.toLearnCards.append(contentsOf: cards)
                self.output.toLearnCards.reverse()
                if !self.output.toLearnCards.isEmpty {
                    self.output.viewState = .hasWords
                } else {
                    self.output.viewState = .nothingWords
                }
            }
            .store(in: &cancellable)
    }
    
    func getCardSets() {
        let request = input.getCardSetSubject
            .map { [unowned self] in
                return self.apiService.getCardSets()
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
            .sink { [unowned self] sets in
                self.output.sets = sets
                print(sets.count)
            }
            .store(in: &cancellable)
    }
    
    func createWordButtonEnable() {
        input.setWordSubject
            .combineLatest(input.setTranslationSubject, input.setIdSubject)
            .map { [unowned self] _ in
                !self.output.word.isEmpty
                && !self.output.translation.isEmpty
                && self.output.setId != nil
            }
            .sink { isEnabled in
                self.output.createWordEnable = !isEnabled
            }
            .store(in: &cancellable)
    }
    
    func chooseSet() {
        input.chooseSetSubject
            .sink { [unowned self] id in
                if let index = self.output.sets.firstIndex(where: { $0.id == id }) {
                    self.output.sets[index].isChosen = true
                    
                    for i in 0 ..< self.output.sets.count {
                        if i != index {
                            self.output.sets[i].isChosen = false
                        }
                    }
                }
                self.output.setId = id
                self.input.setIdSubject.send()
            }
            .store(in: &cancellable)
    }
    
    func createCard() {
        let request = input.createCardSubject
            .map { [unowned self] in
                let currentEmail = UserDefaults.standard.string(forKey: "email")
                let card = CreateCard(setId: self.output.setId ?? 0,
                                      text: self.output.word,
                                      explanation: self.output.translation,
                                      userEmail: currentEmail ?? "")
                
                return self.apiService.createCard(card: card)
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
            .sink { [unowned self] string in
                print(string)
                self.output.isSheet = false
            }
            .store(in: &cancellable)
    }
}

extension CardsLearningViewModel {
    struct Input {
        let getCardSetSubject = PassthroughSubject<Void, Never>()
        let getToLearnCardsSubject = PassthroughSubject<Void, Never>()
        let setWordSubject = PassthroughSubject<Void, Never>()
        let setTranslationSubject = PassthroughSubject<Void, Never>()
        let setIdSubject = PassthroughSubject<Void, Never>()
        let chooseSetSubject = PassthroughSubject<Int, Never>()
        let createCardSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var viewState: ViewState = .nothingWords
        var toLearnCards: [LocalCard] = []
        var word: String = ""
        var translation: String = ""
        var isSheet: Bool = false
        var setId: Int?
        var createWordEnable: Bool = true
        var sets: [LocalCardSet] = []
    }
    
    enum ViewState {
        case nothingWords
        case hasWords
    }
}
