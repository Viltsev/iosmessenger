//
//  TheoryModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import Foundation

final class TheoryModelMapper: BaseModelMapper<ServerTheory, LocalTheory> {
    override func toLocal(serverEntity: ServerTheory) -> LocalTheory {
        LocalTheory(id: serverEntity.id ?? 0,
                    categories: TheoryCategoryModelMapper().toLocal(list: serverEntity.categories)
        )
    }
}

final class TheoryCategoryModelMapper: BaseModelMapper<ServerCategory, LocalCategory> {
    override func toLocal(serverEntity: ServerCategory) -> LocalCategory {
        LocalCategory(id: serverEntity.id ?? 0,
                      title: serverEntity.title ?? "",
                      description: serverEntity.description ?? "",
                      topics: TheoryTopicModelMapper().toLocal(list: serverEntity.topics),
                      theoryList: TheoryListModelMapper().toLocal(list: serverEntity.theoryList)
        )
    }
}

final class TheoryTopicModelMapper: BaseModelMapper<ServerTopic, LocalTopic> {
    override func toLocal(serverEntity: ServerTopic) -> LocalTopic {
        LocalTopic(id: serverEntity.id ?? 0,
                   title: serverEntity.title ?? "",
                   description: serverEntity.description ?? "",
                   theoryList: TheoryListModelMapper().toLocal(list: serverEntity.theoryList),
                   subtopicList: TheorySubtopicModelMapper().toLocal(list: serverEntity.subtopicList)
        )
    }
}

final class TheoryListModelMapper: BaseModelMapper<ServerTheoryList, LocalTheoryList> {
    override func toLocal(serverEntity: ServerTheoryList) -> LocalTheoryList {
        LocalTheoryList(id: serverEntity.id ?? 0,
                        title: serverEntity.title ?? "",
                        level: serverEntity.level ?? "",
                        explanation: serverEntity.explanation ?? "",
                        example: serverEntity.example ?? "",
                        commonMistakeDescription: serverEntity.commonMistakeDescription ?? "",
                        cmWrong: serverEntity.cmWrong ?? "",
                        cmRight: serverEntity.cmRight ?? "")
    }
}

final class TheorySubtopicModelMapper: BaseModelMapper<ServerSubtopicList, LocalSubtopicList> {
    override func toLocal(serverEntity: ServerSubtopicList) -> LocalSubtopicList {
        LocalSubtopicList(id: serverEntity.id ?? 0,
                          title: serverEntity.title ?? "",
                          description: serverEntity.description ?? "",
                          theoryList: TheoryListModelMapper().toLocal(list: serverEntity.theoryList)
        )
    }
}
