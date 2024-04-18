//
//  ChatsViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 17.04.2024.
//

import Foundation
import Combine

class ChatsViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension ChatsViewModel {
    func bind() {
        changeChatMode()
    }
    
    func changeChatMode() {
        input.changeChatModeSubject
            .sink { [unowned self] mode in
                self.output.chatMode = mode
            }
            .store(in: &cancellable)
    }
}

extension ChatsViewModel {
    struct Input {
        let changeChatModeSubject = PassthroughSubject<ChatMessageMode, Never>()
    }
    
    struct Output {
        var chatMode: ChatMessageMode = .sendMessage
    }
    
    enum ChatMessageMode {
        case sendMessage
        case checkGrammar
    }
}
