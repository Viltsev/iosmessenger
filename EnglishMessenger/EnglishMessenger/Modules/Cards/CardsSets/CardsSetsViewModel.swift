//
//  CardsSetsViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 25.04.2024.
//

import Foundation
import Combine

class CardsSetsViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension CardsSetsViewModel {
    func bind() {
        getCardSets()
        createSet()
        createSetButtonEnable()
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
    
    func createSet() {
        let request = input.createSetSubject
            .map { [unowned self] in
                let currentEmail = UserDefaults.standard.string(forKey: "email")
                let set = CreateSet(title: self.output.setTitle,
                                    description: self.output.setDescription,
                                    userEmail: currentEmail ?? "")
                return self.apiService.createSet(set: set)
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
    
    func createSetButtonEnable() {
        input.setTitleSubject
            .combineLatest(input.setDescriptionSubject)
            .map { [unowned self] _ in
                !self.output.setTitle.isEmpty
                && !self.output.setDescription.isEmpty
            }
            .sink { isEnabled in
                self.output.createSetEnabled = !isEnabled
            }
            .store(in: &cancellable)
    }
}

extension CardsSetsViewModel {
    struct Input {
        let getCardSetSubject = PassthroughSubject<Void, Never>()
        let createSetSubject = PassthroughSubject<Void, Never>()
        let setTitleSubject = PassthroughSubject<Void, Never>()
        let setDescriptionSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var sets: [LocalCardSet] = []
        var isSheet: Bool = false
        var setTitle: String = ""
        var setDescription: String = ""
        var createSetEnabled: Bool = true
    }
}
