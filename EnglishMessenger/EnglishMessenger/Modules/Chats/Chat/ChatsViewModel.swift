//
//  ChatsViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 17.04.2024.
//

import Foundation
import Combine
import SwiftUI

class ChatsViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GenaralApi()
    
    init() {
        bind()
    }
}

extension ChatsViewModel {
    func bind() {
        changeChatMode()
        checkGrammar()
    }
    
    func changeChatMode() {
        input.changeChatModeSubject
            .sink { [unowned self] mode in
                self.output.chatMode = mode
            }
            .store(in: &cancellable)
    }
    
    func checkGrammar() {
        let request = input.checkGrammarSubject
            .map { [unowned self] text in
                let newText = text.replacingOccurrences(of: "\n", with: " ")
                self.output.message = newText
                return self.apiService.checkGrammar(text: newText)
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink { error in
                print(error)
            }
            .store(in: &cancellable)
        
        request
            .values()
            .sink { [unowned self] grammarCorrections in
                self.output.correctedMessage = correctMessageGrammar(self.output.message, grammarCorrections)
            }
            .store(in: &cancellable)
    }
    
    func correctMessageGrammar(_ originalMessage: String, _ corrections: [LocalGrammar]) -> String {
        var correctedText = originalMessage
        var cumulativeOffset = 0
            
        for correction in corrections {
            let offset = correction.offset - 1 + cumulativeOffset
            let length = correction.length
            let replacements = correction.replacements
            
            let startIndex = correctedText.index(correctedText.startIndex, offsetBy: offset)
            let endIndex = correctedText.index(startIndex, offsetBy: length)
            let range = startIndex..<endIndex
            
            if let replacement = replacements.first?.value {
                correctedText.replaceSubrange(range, with: replacement)
                let offsetChange = replacement.count - length
                cumulativeOffset += offsetChange
            }
        }
        print(correctedText)
        return correctedText
    }
}

extension ChatsViewModel {
    struct Input {
        let changeChatModeSubject = PassthroughSubject<ChatMessageMode, Never>()
        let checkGrammarSubject = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var chatMode: ChatMessageMode = .sendMessage
        var message: String = ""
        var correctedMessage: String = ""
    }
    
    enum ChatMessageMode {
        case sendMessage
        case checkGrammar
    }
}
