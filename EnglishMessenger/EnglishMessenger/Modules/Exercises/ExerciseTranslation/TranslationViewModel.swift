//
//  TranslationViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation
import Combine

class TranslationViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension TranslationViewModel {
    func bind() {
        checkTranslation()
    }
    
    func checkTranslation() {
        let request = input.checkTranslation
            .map { [unowned self] in
                return self.apiService.sendTranslation(text: self.output.text,
                                                       translation: self.output.translation)
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
            .sink { [unowned self] checkedTranslation in
                self.output.checkedTranslation = checkedTranslation
                self.output.state = .view
            }
            .store(in: &cancellable)
    }
}

extension TranslationViewModel {
    struct Input {
        let checkTranslation = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var text: String = ""
        var translation: String = ""
        var state: ViewState = .view
        var checkedTranslation: LocalTranslation?
    }
    
    enum ViewState {
        case loader
        case view
    }
}
