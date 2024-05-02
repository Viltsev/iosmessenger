//
//  ExerciseQuestionViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation
import Combine

class ExerciseQuestionViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension ExerciseQuestionViewModel {
    func bind() {
        getQuestion()
        sendAnswer()
    }
    
    func getQuestion() {
        let request = input.getQuestionSubject
            .map { [unowned self] in
                return self.apiService.getQuestion()
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
            .sink { [unowned self] question in
                self.output.question = question
                self.output.state = .view
            }
            .store(in: &cancellable)
    }
    
    func sendAnswer() {
        let request = input.sendAnswerSubject
            .map { [unowned self] in
                return self.apiService.sendAnswer(question: self.output.question,
                                                  answer: self.output.answer)
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
            .sink { [unowned self] checkedAnswer in
                self.output.checkedAnswer = checkedAnswer
                self.output.state = .view
            }
            .store(in: &cancellable)
    }
}

extension ExerciseQuestionViewModel {
    struct Input {
        let getQuestionSubject = PassthroughSubject<Void, Never>()
        let sendAnswerSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var state: ViewState = .loader
        var answer: String = ""
        var question: String = ""
        var checkedAnswer: LocalQuestion?
    }
    
    enum ViewState {
        case loader
        case view
    }
}
