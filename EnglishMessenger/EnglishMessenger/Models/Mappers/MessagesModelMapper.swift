//
//  MessagesModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 16.04.2024.
//

import Foundation

final class MessagesModelMapper: BaseModelMapper<ServerMessage, Message> {
    override func toLocal(serverEntity: ServerMessage) -> Message {
        Message(idChat: serverEntity.idChat,
                type: serverEntity.type,
                content: serverEntity.content,
                sender: serverEntity.sender,
                senderId: serverEntity.senderId,
                recipientId: serverEntity.recipientId
        )
    }
}
