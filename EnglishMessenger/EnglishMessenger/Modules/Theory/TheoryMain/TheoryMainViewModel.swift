//
//  TheoryMainViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import Foundation
import Combine

class TheoryMainViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GeneralApi()
    
    init() {
        bind()
    }
}

extension TheoryMainViewModel {
    func bind() {
        getTheory()
    }
    
    func getTheory() {
        let request = input.getTheorySubject
            .map { [unowned self] in
                return self.apiService.getTheory()
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .failures()
            .sink {
                error in
                print(error)
            }
            .store(in: &cancellable)
        
        request
            .values()
            .sink { [unowned self] theory in
                self.output.theory = theory.categories
            }
            .store(in: &cancellable)
    }
}

extension TheoryMainViewModel {
    struct Input {
        let getTheorySubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var theory: [LocalCategory] = []
    }
}
