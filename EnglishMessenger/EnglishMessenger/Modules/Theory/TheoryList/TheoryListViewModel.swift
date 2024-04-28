//
//  TheoryListViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import Foundation
import Combine

class TheoryListViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension TheoryListViewModel {
    func bind() {
        
    }
}

extension TheoryListViewModel {
    struct Input {
        
    }
    
    struct Output {
        var theory: LocalTopic?
    }
}
