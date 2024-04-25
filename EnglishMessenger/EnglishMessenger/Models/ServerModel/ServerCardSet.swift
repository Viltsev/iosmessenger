//
//  ServerCardSet.swift
//  EnglishMessenger
//
//  Created by Данила on 24.04.2024.
//

import Foundation

struct ServerCardSet: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let userEmail: String?
    let cardList: [ServerCard]?
    let toLearn: [ServerCard]?
    let learned: [ServerCard]?
}
