//
//  ServerUser.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation

struct ServerUser: Codable {
    var username: String?
    var email: String?
    var phone: String?
    var dateOfBirth: String?
    var languageLevel: String?
}
