//
//  TestResultsView.swift
//  EnglishMessenger
//
//  Created by Данила on 05.03.2024.
//

import SwiftUI

struct TestResultsView: View {
     @EnvironmentObject var viewModel: TestingViewModel
    
    var body: some View {
        Color.lightPinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension TestResultsView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            VStack(spacing: 25) {
                TitleTextView(text: "Congratulations!\nYour level is", size: 30)
                TitleTextView(text: viewModel.output.currentLevel, size: 50)
                Spacer()
                Image("pinkCircle")
                    .scaledToFit()
                    .overlay {
                        Image("doneMark")
                            .scaledToFit()
                    }
                Spacer()
            }
            .padding(.vertical, 50)
            Spacer()
            PurpleButtonView(text: "Let's go!", actionPublisher: viewModel.input.goToProfileSubject)
                .padding(.bottom, 20)
        }
        
    }
}

//#Preview {
//    TestResultsView()
//}
