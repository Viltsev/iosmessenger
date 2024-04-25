//
//  CardViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 23.04.2024.
//

import Foundation
import Combine

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = [
        Card(word: "Hello", translation: "Привет"),
        Card(word: "Trust", translation: "Доверять"),
        Card(word: "Faith", translation: "Вера")
    ]
    @Published var currentCount: Int = 1
}

extension CardViewModel {
    struct Card: Identifiable {
        var id: UUID = UUID()
        var word: String
        var translation: String
        var isFlipped: Bool = false
    }
}
