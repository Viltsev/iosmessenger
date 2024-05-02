//
//  ExerciseQuestionModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import Foundation

final class ExerciseQuestionModelMapper: BaseModelMapper<ServerQuestion, LocalQuestion> {
    override func toLocal(serverEntity: ServerQuestion) -> LocalQuestion {
        LocalQuestion(correctedAnswer: serverEntity.corrected_answer ?? "",
                      explanation: serverEntity.explanation)
    }
}
