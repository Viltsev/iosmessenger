//
//  CreateCard.swift
//  EnglishMessenger
//
//  Created by Данила on 25.04.2024.
//

import Foundation

struct CreateCard: Codable {
    let setId: Int
    let text: String
    let explanation: String
    let userEmail: String
}
