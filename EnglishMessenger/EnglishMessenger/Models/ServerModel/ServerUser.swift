//
//  ServerUser.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation

struct ServerUser: Codable {
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var phone: String?
    var dateOfBirth: String?
    var languageLevel: String?
    var photo: String?
    var emailFriends: [String]
    var chatRoomList: [ServerChatRoomList]?
}

struct ServerChatRoomList: Codable {
    var chatId: String?
    var lastMessage: String?
}
