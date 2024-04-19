//
//  LocalGrammar.swift
//  EnglishMessenger
//
//  Created by Данила on 18.04.2024.
//

import Foundation

struct LocalGrammar: Identifiable {
    let id: UUID = UUID()
    let message: String
    let replacements: [LocalReplacement]
    let offset: Int
    let length: Int
    let rule: LocalRule
}

struct LocalReplacement {
    let value: String
}

struct LocalRule {
    let description: String
}
