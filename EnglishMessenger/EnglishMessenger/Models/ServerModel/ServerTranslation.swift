//
//  ServerTranslation.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation

struct ServerTranslation: Codable {
    let corrected_text: String?
    let explanations: [String]
}
