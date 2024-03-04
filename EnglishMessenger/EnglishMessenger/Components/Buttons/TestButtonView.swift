//
//  TestButtonView.swift
//  EnglishMessenger
//
//  Created by Данила on 03.03.2024.
//

import SwiftUI

struct TestButtonView: View {
    @State private var isActive: Bool = false
    var text: String
    
    var body: some View {
        Button {
            withAnimation(.smooth) {
                isActive.toggle()
            }
        } label: {
            VStack {
                Text(text)
                    .foregroundColor(isActive ? .lightPinky : .mainPurple)
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
        if !isActive {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(.mainPurple)
        } else {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .foregroundColor(.mainPurple)
        }
    }
}

//#Preview {
//    TestButtonView()
//}
