//
//  InterestsModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 03.04.2024.
//

import Foundation

final class InterestsModelMapper: BaseModelMapper<ServerInterests, LocalInterests> {
    override func toLocal(serverEntity: ServerInterests) -> LocalInterests {
        LocalInterests(id: serverEntity.id ?? 0,
                       interest: serverEntity.interest ?? "",
                       selection: .notSelected
        )
    }
}
