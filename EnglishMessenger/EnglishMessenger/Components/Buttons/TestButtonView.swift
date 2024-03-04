//
//  TestButtonView.swift
//  EnglishMessenger
//
//  Created by Данила on 03.03.2024.
//

import SwiftUI
import Combine

struct TestButtonView: View {
    let id: Int
    var actionPublisher: PassthroughSubject<(Int, Int, String), Never>
    var text: String
    let currentAnswerId: Int
    let buttonId: Int
    
    var body: some View {
        Button {
            withAnimation(.bouncy) {
                actionPublisher.send((id, buttonId, text))
            }
        } label: {
            VStack {
                Text(text)
                    .foregroundColor(currentAnswerId == buttonId ? .lightPinky : .mainPurple)
                    .font(.custom("Montserrat-Light", size: 25))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background (
                roundedRectangle()
            )
        }
        .padding(.horizontal, 16)
    }
}

extension TestButtonView {
    @ViewBuilder
    func roundedRectangle() -> some View {
        if currentAnswerId != buttonId {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(.mainPurple)
        } else {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .foregroundColor(.mainPurple)
        }
    }
}
