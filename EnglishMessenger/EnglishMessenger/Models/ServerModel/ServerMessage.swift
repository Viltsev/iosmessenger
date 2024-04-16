//
//  ServerMessage.swift
//  EnglishMessenger
//
//  Created by Данила on 15.04.2024.
//

import Foundation

struct ServerMessage: Codable {
    var idChat: UUID = UUID()
    let type: String
    let content: String?
    let sender: String
    let senderId: String?
    let recipientId: String?
}
