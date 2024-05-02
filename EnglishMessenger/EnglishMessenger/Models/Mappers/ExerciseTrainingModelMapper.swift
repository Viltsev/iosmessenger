//
//  ExerciseTrainingModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import Foundation

final class ExerciseTrainingModelMapper: BaseModelMapper<ServerTraining, LocalTraining> {
    override func toLocal(serverEntity: ServerTraining) -> LocalTraining {
        LocalTraining(exercise: serverEntity.exercise ?? "",
                      rightAnswer: serverEntity.right_answer ?? "")
    }
}
