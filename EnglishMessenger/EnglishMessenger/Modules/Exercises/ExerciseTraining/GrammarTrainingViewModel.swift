//
//  GrammarTrainingViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import Foundation
import Combine

class GrammarTrainingViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension GrammarTrainingViewModel {
    func bind() {
        getExercises()
    }
    
    func getExercises() {
        let request = input.trainExercisesSubject
            .map { [unowned self] in
                return self.apiService.getTrainSentences(topic: self.output.topic)
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink {
                error in
                self.output.state = .error
                print(error)
            }
            .store(in: &cancellable)
        
        request
            .values()
            .sink { [unowned self] exercises in
                self.output.exercises = exercises
                if exercises.isEmpty {
                    self.output.state = .error
                } else {
                    self.output.isCorrect = true
                    self.output.state = .view
                }
            }
            .store(in: &cancellable)
    }
}

extension GrammarTrainingViewModel {
    struct Input {
       let trainExercisesSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var topic: String = ""
        var state: ViewState = .view
        var exercises: [LocalTraining] = []
        var isCorrect: Bool = false
    }
    
    enum ViewState {
        case view
        case loader
        case error
    }
}
