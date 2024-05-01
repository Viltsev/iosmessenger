//
//  ServerTheory.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import Foundation

struct ServerTheory: Codable {
    let id: Int?
    let categories: [ServerCategory]
}

struct ServerCategory: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let topics: [ServerTopic]
    let theoryList: [ServerTheoryList]
}

struct ServerTopic: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let theoryList: [ServerTheoryList]
    let subtopicList: [ServerSubtopicList]
}

struct ServerTheoryList: Codable {
    let id: Int?
    let title: String?
    let level: String?
    let explanation: String?
    let example: String?
    let commonMistakeDescription: String?
    let cmWrong: String?
    let cmRight: String?
}

struct ServerSubtopicList: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let theoryList: [ServerTheoryList]
}
