//
//  OnboardingViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 01.03.2024.
//

import Foundation
import Combine
import CombineExt
import UIKit
import SwiftUI

class OnboardingViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension OnboardingViewModel {
    func bind() {
        
    }
}

extension OnboardingViewModel {
    struct Input {
        
    }
    
    struct Output {
        var username: String = "@"
        var dateOfBirth: String = ""
    }
}
