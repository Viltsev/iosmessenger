//
//  TranslationCheckViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation
import Combine

class TranslationCheckViewModel: ObservableObject {
    @Published var output: Output = Output()
}

extension TranslationCheckViewModel {
    struct Output {
        var text: String = ""
        var translation: String = ""
        var checkedTranslation: LocalTranslation?
    }
}
