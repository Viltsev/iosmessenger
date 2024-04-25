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
    let cardList: [ServerCard]
    let toLearn: [ServerCard]
    let learned: [ServerCard]
    var isChosen: Bool = false
}
