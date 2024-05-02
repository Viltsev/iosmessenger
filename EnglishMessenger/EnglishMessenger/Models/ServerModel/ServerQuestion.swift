//
//  ServerQuestion.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation

struct ServerQuestion: Codable {
    let corrected_answer: String?
    let explanation: [String]
}

