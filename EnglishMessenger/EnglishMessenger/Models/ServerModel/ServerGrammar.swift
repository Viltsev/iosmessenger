//
//  ServerGrammar.swift
//  EnglishMessenger
//
//  Created by Данила on 18.04.2024.
//

import Foundation

struct ServerGrammar: Codable {
    let message: String?
    let replacements: [ServerReplacement]?
    let offset: Int?
    let length: Int?
    let rule: ServerRule?
}

struct ServerReplacement: Codable {
    let value: String?
}

struct ServerRule: Codable {
    let description: String?
}
