//
//  DictionaryViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 03.05.2024.
//

import Foundation
import Combine

class DictionaryViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension DictionaryViewModel {
    func bind() {
        getCardSets()
        createCard()
        chooseSet()
        createWordButtonEnable()
        getRussianTranslation()
        getEnglishTranslation()
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
    
    func createWordButtonEnable() {
        input.setIdSubject
            .map { [unowned self] _ in
                self.output.setId != nil
            }
            .sink { isEnabled in
                self.output.createWordEnable = !isEnabled
            }
            .store(in: &cancellable)
    }
    
    func getRussianTranslation() {
        let request = input.getRussianTranslationSubject
            .map { [unowned self] in
                return self.apiService.getRussianTranslation(word: self.output.searchedWord.lowercased())
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
            .sink { [unowned self] translation in
                self.output.dictionary.reverse()
                self.output.dictionary.append(translation)
                self.output.dictionary.reverse()
                self.output.searchedWord = ""
            }
            .store(in: &cancellable)
    }
    
    func getEnglishTranslation() {
        let request = input.getEnglishTranslationSubject
            .map { [unowned self] in
                return self.apiService.getEnglishTranslation(word: self.output.searchedWord.lowercased())
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
            .sink { [unowned self] translation in
                self.output.dictionary.reverse()
                self.output.dictionary.append(contentsOf: translation)
                self.output.dictionary.reverse()
                self.output.searchedWord = ""
            }
            .store(in: &cancellable)
    }
}

extension DictionaryViewModel {
    struct Input {
        let getRussianTranslationSubject = PassthroughSubject<Void, Never>()
        let getEnglishTranslationSubject = PassthroughSubject<Void, Never>()
        let setIdSubject = PassthroughSubject<Void, Never>()
        let createCardSubject = PassthroughSubject<Void, Never>()
        let getCardSetSubject = PassthroughSubject<Void, Never>()
        let chooseSetSubject = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var translationMode: TranslationMode = .english
        var searchedWord: String = ""
        var dictionary: [LocalDictionary] = []
        var word: String = ""
        var translation: String = ""
        var sets: [LocalCardSet] = []
        var setId: Int?
        var createWordEnable: Bool = true
        var isSheet: Bool = false
    }
    
    enum TranslationMode {
        case english
        case russian
    }
}
