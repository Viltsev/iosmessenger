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
        fetchTestData()
        saveInterestId()
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
                    self.apiService.sendInterestsList(interestsIds: self.output.interestIdList)
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
    
    func fetchTestData() {
        let request = input.fetchInterestSubject
            .map {
                self.apiService.fetchInterestsList()
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
            .sink { [weak self] interestsData in
                guard let self else { return }
                self.output.interestsArray = interestsData
            }
            .store(in: &cancellable)
    }
    
    func saveInterestId() {
        input.saveInterestIdSubject
            .sink { id in
                if self.output.interestsArray[id - 1].selection == .notSelected {
                    self.output.interestIdList.append(id)
                    self.output.interestsArray[id - 1].selection = .selected
                } else {
                    self.output.interestIdList.removeAll(where: { $0 == id })
                    self.output.interestsArray[id - 1].selection = .notSelected
                }
            }
            .store(in: &cancellable)
    }
}

extension OnboardingViewModel {
    struct Input {
        let setupOnboardingSubject = PassthroughSubject<Void, Never>()
        let fetchInterestSubject = PassthroughSubject<Void, Never>()
        let saveInterestIdSubject = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var username: String = ""
        var dateOfBirth: String = ""
        var image: UIImage?
        var photo: String = ""
        var interestsArray: [LocalInterests] = []
        var interestIdList: [Int] = []
    }
}
