//
//  UserModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation

final class UserModelMapper: BaseModelMapper<ServerUser, User> {
    override func toLocal(serverEntity: ServerUser) -> User {
        User(firstName: serverEntity.firstName ?? "",
             lastName: serverEntity.lastName ?? "",
             username: serverEntity.username ?? "",
             email: serverEntity.email ?? "",
             phone: serverEntity.phone ?? "",
             dateOfBirth: serverEntity.dateOfBirth ?? "",
             languageLevel: serverEntity.languageLevel ?? "",
             photo: "https://s3.timeweb.cloud/c69f4719-fa278707-76a9-4ddc-bc9e-bc582ad152d2/\(serverEntity.photo ?? "1.jpg")", 
             chatRoomList: ChatRoomModelMapper().toLocal(list: serverEntity.chatRoomList))
    }
}

final class ChatRoomModelMapper: BaseModelMapper<ServerChatRoomList, ChatRoomList> {
    override func toLocal(serverEntity: ServerChatRoomList) -> ChatRoomList {
        ChatRoomList(lastMessage: serverEntity.lastMessage ?? "")
    }
}
