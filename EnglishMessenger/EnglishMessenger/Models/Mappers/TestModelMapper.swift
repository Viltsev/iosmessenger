//
//  TestModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 04.03.2024.
//

import Foundation

final class TestModelMapper: BaseModelMapper<ServerTest, LocalTest> {
    override func toLocal(serverEntity: ServerTest) -> LocalTest {
        LocalTest(id: serverEntity.id ?? 0,
                  question: serverEntity.question ?? "question",
                  answerOne: serverEntity.answerOne ?? "answer 1",
                  answerTwo: serverEntity.answerTwo ?? "answer 2",
                  answerThree: serverEntity.answerThree ?? "answer 3",
                  answerFour: serverEntity.answerFour,
                  rightAnswer: serverEntity.rightAnswer ?? "right answer")
    }
}
