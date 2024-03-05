//
//  LocalTest.swift
//  EnglishMessenger
//
//  Created by Данила on 04.03.2024.
//

import Foundation

struct LocalTest: Identifiable {
    let id: Int
    let question: String
    let answerOne: String
    let answerTwo: String
    let answerThree: String
    let answerFour: String?
    let rightAnswer: String
    var currentAnswerId: Int = 0
}
