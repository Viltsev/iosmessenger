//
//  LocalInterests.swift
//  EnglishMessenger
//
//  Created by Данила on 03.04.2024.
//

import Foundation

enum IsSelected {
    case selected
    case notSelected
}

struct LocalInterests: Identifiable {
    let id: Int
    let interest: String
    var selection: IsSelected
}
