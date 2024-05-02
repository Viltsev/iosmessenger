//
//  GTExercisesViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation
import Combine

class GTExercisesViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension GTExercisesViewModel {
    func bind() {
        writeAnswer()
        checkAnswers()
    }
    
    func writeAnswer() {
        input.writeAnswerSubject
            .sink { [unowned self] (answer, id) in
                if let index = self.output.exercises.firstIndex(where: { $0.id == id }) {
                    self.output.exercises[index].currentAnswer = answer
                }
            }
            .store(in: &cancellable)
    }
    
    func checkAnswers() {
        input.checkAnswersSubject
            .sink { [unowned self] _ in
                for exercise in self.output.exercises {
                    if exercise.currentAnswer.lowercased() == exercise.rightAnswer.lowercased() {
                        if let index = self.output.exercises.firstIndex(where: { $0.id == exercise.id }) {
                            self.output.exercises[index].isCorrect = true
                        }
                    }
                }
                self.output.state = .showCorrect
            }
            .store(in: &cancellable)
    }
}

extension GTExercisesViewModel {
    struct Input {
        let writeAnswerSubject = PassthroughSubject<(String, UUID), Never>()
        let checkAnswersSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var exercises: [LocalTraining] = []
        var state: ViewState = .answers
    }
    
    enum ViewState {
        case answers
        case showCorrect
    }
}
