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
    let apiService = GenaralApi()
    
    init() {
        bind()
    }
}

extension OnboardingViewModel {
    func bind() {
        setupOnboardingData()
    }
    
    func setupOnboardingData() {
        input.setupOnboardingSubject
            .sink { [unowned self] in
                let currentEmail = UserDefaults.standard.string(forKey: "email")
                let dateOfBirth = getDate(dateString: output.dateOfBirth)
                if let currentEmail = currentEmail, let date = dateOfBirth {
                    let onboardingData = Onboarding(email: currentEmail,
                                                    username: output.username,
                                                    dateOfBirth: date,
                                                    photo: output.photo)
                    self.apiService.sendOnboardingData(onboardingData: onboardingData)
                }
                UserDefaults.standard.removeObject(forKey: "avatar")
            }
            .store(in: &cancellable)
    }
    
    func getDate(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

extension OnboardingViewModel {
    struct Input {
        let setupOnboardingSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var username: String = ""
        var dateOfBirth: String = ""
        var image: UIImage?
        var photo: String = ""
    }
}
