//
//  LocalTraining.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import Foundation

struct LocalTraining: Identifiable, Hashable {
    var id: UUID = UUID()
    let exercise: String
    let rightAnswer: String
    var currentAnswer: String = ""
    var isCorrect: Bool = false
}
