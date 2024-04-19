//
//  GrammarModelMapper.swift
//  EnglishMessenger
//
//  Created by Данила on 18.04.2024.
//

import Foundation

final class GrammarModelMapper: BaseModelMapper<ServerGrammar, LocalGrammar> {
    override func toLocal(serverEntity: ServerGrammar) -> LocalGrammar {
        LocalGrammar(message: serverEntity.message ?? "",
                     replacements: ReplacementModelMapper().toLocal(list: serverEntity.replacements),
                     offset: serverEntity.offset ?? 0,
                     length: serverEntity.length ?? 0,
                     rule: RuleModelMapper().toLocal(serverEntity: serverEntity.rule ?? ServerRule(description: "")))
    }
}

final class ReplacementModelMapper: BaseModelMapper<ServerReplacement, LocalReplacement> {
    override func toLocal(serverEntity: ServerReplacement) -> LocalReplacement {
        LocalReplacement(value: serverEntity.value ?? "")
    }
}


final class RuleModelMapper: BaseModelMapper<ServerRule, LocalRule> {
    override func toLocal(serverEntity: ServerRule) -> LocalRule {
        LocalRule(description: serverEntity.description ?? "")
    }
}

