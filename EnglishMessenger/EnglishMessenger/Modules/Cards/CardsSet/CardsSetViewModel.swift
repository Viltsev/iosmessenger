//
//  CardsSetViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 25.04.2024.
//

import Foundation
import Combine

class CardsSetViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension CardsSetViewModel {
    func bind() {
        deleteCard()
    }
    
    func deleteCard() {
        let request = input.deleteCardSubject
            .map { [unowned self] card in
                if let index = self.output.cardList.firstIndex(where: { $0.id == card.id }) {
                    self.output.cardList.remove(at: index)
                }
                return apiService.deleteCard(card: card)
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

extension CardsSetViewModel {
    struct Input {
        let deleteCardSubject = PassthroughSubject<LocalCard, Never>()
    }
    
    struct Output {
        var cardSet: LocalCardSet?
        var cardList: [LocalCard] = []
    }
}
