//
//  TheoryCardViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 29.04.2024.
//

import Foundation
import Combine

class TheoryCardViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension TheoryCardViewModel {
    func bind() {
        getExercises()
    }
    
    func getExercises() {
        let request = input.trainExercisesSubject
            .map { [unowned self] topic in
                return self.apiService.getTrainSentences(topic: topic)
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink { error in
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
                    self.output.isShow = true
                    self.output.state = .view
                }
            }
            .store(in: &cancellable)
    }
}

extension TheoryCardViewModel {
    struct Input {
        let trainExercisesSubject = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var theory: LocalTheoryList?
        var state: ViewState = .view
        var exercises: [LocalTraining] = []
        var isShow: Bool = false
    }
    
    enum ViewState {
        case loader
        case view
        case error
    }
}
