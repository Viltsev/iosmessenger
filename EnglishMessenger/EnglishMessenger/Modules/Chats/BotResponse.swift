//
//  BotResponse.swift
//  EnglishMessenger
//
//  Created by Данила on 03.04.2024.
//

import Foundation

func getBotResponse(message: String) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("hello") {
        return "Hey there!"
    } else if tempMessage.contains("goodbye") {
        return "Talk to you later!"
    } else {
        return "something..."
    }
}
