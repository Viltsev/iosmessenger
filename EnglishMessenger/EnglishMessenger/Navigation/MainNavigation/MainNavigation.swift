//
//  MainNavigation.swift
//  EnglishMessenger
//
//  Created by Данила on 15.04.2024.
//

import Foundation

enum MainNavigation: Hashable {
    case pushChatView(User)
    case pushCardsView
    case pushCardsLearned
    case pushCardsLearning
    case pushCardsSets
}
