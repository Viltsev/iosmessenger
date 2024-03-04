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
    var size: Int
    var actionPublisher: PassthroughSubject<Void, Never>? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        content(text: self.text, buttonColor: self.buttonColor, size: CGFloat(self.size))
    }
}

extension ButtonView {
    @ViewBuilder
    func content(text: String, buttonColor: Color, size: CGFloat) -> some View {
        Button(action: buttonTap, label: {
            Text(text)
                .font(.custom("Alice-Regular", size: size))
                .foregroundStyle(buttonColor)
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

//#Preview {
//    ButtonView(text: "Registration", buttonColor: .mint)
//}
