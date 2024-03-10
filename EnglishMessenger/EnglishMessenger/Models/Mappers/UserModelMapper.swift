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
             photo: serverEntity.photo ?? Data())
    }
}
