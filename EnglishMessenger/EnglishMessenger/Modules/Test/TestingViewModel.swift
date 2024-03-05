//
//  TestingViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 04.03.2024.
//

import Foundation
import Combine
import CombineExt

class TestingViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GenaralApi()
    
    init() {
        bind()
    }
}

extension TestingViewModel {
    func bind() {
        fetchTestData()
        setAnswers()
        checkResults()
        goToProfileAction()
    }
    
    func fetchTestData() {
        let request = input.fetchTestDataSubject
            .map {
                self.apiService.fetchTestData()
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
            .sink { [weak self] testData in
                guard let self else { return }
                self.output.testData = testData
            }
            .store(in: &cancellable)
    }
    
    func setAnswers() {
        input.setAnswersSubject
            .sink { [weak self] (id, currentAnswerId, currentAnswer) in
                guard let self = self else { return }
                
                if let questionIndex = self.output.testData.firstIndex(where: { $0.id == id}) {
                    self.output.testData[questionIndex].currentAnswerId = currentAnswerId
                }
                
                
                if let index = self.output.answers.firstIndex(where: { $0.questionId == id }) {
                    self.output.answers[index] = Answer(questionId: id, currentAnswer: currentAnswer)
                } else {
                    self.output.answers.append(Answer(questionId: id, currentAnswer: currentAnswer))
                }
            }
            .store(in: &cancellable)
    }
    
    func checkResults() {
        let request = input.checkResultsSubject
            .map { [unowned self] in
                self.apiService.getCurrentLevel(answerList: self.output.answers)
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
            .sink { [weak self] level in
                guard let self else { return }
                self.output.currentLevel = level
                UserDefaults.standard.removeObject(forKey: "languageLevel")
                UserDefaults.standard.setValue(level, forKey: "languageLevel")
            }
            .store(in: &cancellable)
    }
    
    func goToProfileAction() {
        input.goToProfileSubject
            .sink { 
                AuthenticationService.shared.status.send(true)
            }
            .store(in: &cancellable)
    }
}

extension TestingViewModel {
    struct Input {
        let fetchTestDataSubject = PassthroughSubject<Void, Never>()
        let setAnswersSubject = PassthroughSubject<(Int, Int, String), Never>()
        let checkResultsSubject = PassthroughSubject<Void, Never>()
        let goToProfileSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var pageNumber: Int = 0
        var testData: [LocalTest] = []
        var answers: [Answer] = []
        var currentLevel: String = ""
    }
}
