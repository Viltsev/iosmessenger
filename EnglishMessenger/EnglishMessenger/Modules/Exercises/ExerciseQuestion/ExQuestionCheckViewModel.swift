//
//  ExQuestionCheckViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation
import Combine

class ExQuestionCheckViewModel: ObservableObject {
    @Published var output: Output = Output()
}

extension ExQuestionCheckViewModel {
    struct Output {
        var question: String = ""
        var answer: String = ""
        var checkedAnswer: LocalQuestion?
    }
}
