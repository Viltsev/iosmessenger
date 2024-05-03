//
//  DictionaryModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 03.05.2024.
//

import Foundation

final class DictionaryModelMapper: BaseModelMapper<ServerDictionary, LocalDictionary> {
    override func toLocal(serverEntity: ServerDictionary) -> LocalDictionary {
        LocalDictionary(id: serverEntity.id ?? "",
                        word: serverEntity.word ?? "",
                        description: serverEntity.description ?? "")
    }
}
