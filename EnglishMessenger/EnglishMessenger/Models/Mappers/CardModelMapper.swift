//
//  CardModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 24.04.2024.
//

import Foundation

final class CardModelMapper: BaseModelMapper<ServerCard, LocalCard> {
    override func toLocal(serverEntity: ServerCard) -> LocalCard {
        LocalCard(id: serverEntity.id ?? 0,
                  setId: serverEntity.setId ?? 0,
                  text: serverEntity.text ?? "",
                  explanation: serverEntity.explanation ?? "",
                  userEmail: serverEntity.userEmail ?? ""
        )
    }
}
