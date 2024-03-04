//
//  OnboardingUsernameView.swift
//  EnglishMessenger
//
//  Created by Данила on 01.03.2024.
//

import SwiftUI

struct OnboardingUsernameView: View {
    var body: some View {
        Color.lightPinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension OnboardingUsernameView {
    @ViewBuilder
    func content() -> some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer()
            TitleTextView(text: "Your Username", size: 35)
            Text("@viltsev")
            Spacer()
            // OnboardingNavigationView(pageNumber: 0)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    OnboardingUsernameView()
}
