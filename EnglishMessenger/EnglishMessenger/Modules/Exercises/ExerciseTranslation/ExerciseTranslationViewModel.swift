//
//  ExerciseTranslationViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import Foundation
import Combine

class ExerciseTranslationViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension ExerciseTranslationViewModel {
    func bind() {
       generateText()
    }
    
    func generateText() {
        let request = input.generateTextSubject
            .map { [unowned self] in
                return self.apiService.getTranslation(topic: self.output.topic)
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
            .sink { [unowned self] text in
                self.output.text = text
                self.output.isGenerated = true
                self.output.state = .view
            }
            .store(in: &cancellable)
    }
}

extension ExerciseTranslationViewModel {
    struct Input {
        let generateTextSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var state: ViewState = .view
        var topic: String = ""
        var text: String = ""
        var isGenerated: Bool = false
    }
    
    enum ViewState {
        case view
        case loader
    }
}
