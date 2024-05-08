//
//  MainTab.swift
//  EnglishMessenger
//
//  Created by Данила on 06.03.2024.
//

import Foundation
import SwiftUI

enum MainTab: String, CaseIterable {
    case chats = "message.fill"
    case profile = "house.fill"
    case dictionary = "book.fill"
    case exercises = "square.grid.2x2.fill"
    
    var title: String {
        switch self {
        case .chats:
            return "Чаты"
        case .profile:
            return "Профиль"
        case .dictionary:
            return "Словарь"
        case .exercises:
            return "Обучение"
        }
    }
}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: MainTab
    var isAnimating: Bool?
}
