//
//  CardSetModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 25.04.2024.
//

import Foundation

final class CardSetModelMapper: BaseModelMapper<ServerCardSet, LocalCardSet> {
    override func toLocal(serverEntity: ServerCardSet) -> LocalCardSet {
        LocalCardSet(id: serverEntity.id ?? 0,
                     title: serverEntity.title ?? "",
                     description: serverEntity.description ?? "",
                     userEmail: serverEntity.userEmail ?? "",
                     cardList: CardModelMapper().toLocal(list: serverEntity.cardList),
                     toLearn: CardModelMapper().toLocal(list: serverEntity.toLearn),
                     learned: CardModelMapper().toLocal(list: serverEntity.learned)
        )
    }
}
