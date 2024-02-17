//
//  StartViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import Foundation
import Combine

class StartViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension StartViewModel {
    func bind() {
        pushRegistrationView()
        pushAuthView()
    }
    
    func pushAuthView() {
        input.pushAuthSubject
            .sink {
                print("push to auth view")
            }
            .store(in: &cancellable)
    }
    
    func pushRegistrationView() {
        input.pushRegistrationSubject
            .sink {
                print("push to reg view")
            }
            .store(in: &cancellable)
    }
}

extension StartViewModel {
    struct Input {
        let pushRegistrationSubject = PassthroughSubject<Void, Never>()
        let pushAuthSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        
    }
}
