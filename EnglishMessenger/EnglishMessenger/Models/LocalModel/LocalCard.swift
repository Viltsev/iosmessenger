//
//  LocalCard.swift
//  EnglishMessenger
//
//  Created by Данила on 24.04.2024.
//

import Foundation

struct LocalCard: Identifiable, Hashable, Codable {
    let id: Int
    let setId: Int
    let text: String
    let explanation: String
    let userEmail: String
}
