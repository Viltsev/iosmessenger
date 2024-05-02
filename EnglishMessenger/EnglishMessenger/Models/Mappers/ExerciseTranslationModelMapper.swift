//
//  ExerciseTranslationModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation

final class ExerciseTranslationModelMapper: BaseModelMapper<ServerTranslation, LocalTranslation> {
    override func toLocal(serverEntity: ServerTranslation) -> LocalTranslation {
        LocalTranslation(correctedText: serverEntity.corrected_text ?? "",
                         explanations: serverEntity.explanations)
    }
}
