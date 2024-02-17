//
//  ButtonView.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI
import Combine

struct ButtonView: View {
    var text: String
    var buttonColor: Color
    var textColor: Color
    var actionPublisher: PassthroughSubject<Void, Never>? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        content(text: self.text, buttonColor: self.buttonColor, textColor: self.textColor)
    }
}

extension ButtonView {
    @ViewBuilder
    func content(text: String, buttonColor: Color, textColor: Color) -> some View {
        Button(action: buttonTap, label: {
            HStack {
                Text(text)
                    .font(.title2)
                    .fontDesign(.serif)
                    .foregroundStyle(textColor)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(buttonColor)
            .clipShape(.buttonBorder)
            .padding(.horizontal, 16)
        })
    }
}

extension ButtonView {
    func buttonTap() {
        if let actionPublisher = actionPublisher {
            actionPublisher.send()
        } else if let action = action {
            action()
        }
    }
}

#Preview {
    ButtonView(text: "Registration", buttonColor: .mint, textColor: .white)
}
