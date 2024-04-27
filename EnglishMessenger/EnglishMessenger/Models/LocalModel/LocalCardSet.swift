//
//  CardSet.swift
//  EnglishMessenger
//
//  Created by Данила on 25.04.2024.
//

import Foundation

struct LocalCardSet: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let userEmail: String
    let cardList: [LocalCard]
    let toLearn: [LocalCard]
    let learned: [LocalCard]
    var isChosen: Bool = false
}
