//
//  OnboardingNavigation.swift
//  EnglishMessenger
//
//  Created by Данила on 01.03.2024.
//

import SwiftUI

struct OnboardingNavigationView: View {
    var pageNumber: Int
    
    var body: some View {
        content()
    }
}

extension OnboardingNavigationView {
    @ViewBuilder
    func content() -> some View {
        HStack {
            Spacer()
            HStack {
                ForEach(0..<5) { index in
                    Circle()
                        .foregroundStyle(index == pageNumber ? .mainPurple : .lightPurple)
                        .frame(width: 16, height: 16)
                        .offset(y: 2)
                }
            }
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    OnboardingNavigationView()
//}
