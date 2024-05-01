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
    
    init() {
        bind()
    }
}

extension ExerciseTranslationViewModel {
    func bind() {
        
    }
}

extension ExerciseTranslationViewModel {
    struct Input {
        
    }
    
    struct Output {
        var viewState: ViewState = .loader
    }
    
    enum ViewState {
        case view
        case loader
    }
}
