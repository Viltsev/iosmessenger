//
//  CardsSetViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 25.04.2024.
//

import Foundation
import Combine

class CardsSetViewModel: ObservableObject {
    @Published var output: Output = Output()
}

extension CardsSetViewModel {
    struct Output {
        var cardSet: LocalCardSet?
    }
}
