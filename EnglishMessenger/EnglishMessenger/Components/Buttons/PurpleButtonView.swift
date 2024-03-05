//
//  PurpleButtonView.swift
//  EnglishMessenger
//
//  Created by Данила on 03.03.2024.
//

import SwiftUI
import Combine

struct PurpleButtonView: View {
    let text: String
    var actionPublisher: PassthroughSubject<Void, Never>? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            buttonTap()
            //actionPublisher.send()
        } label: {
            VStack {
                Text(text)
                    .foregroundColor(.lightPinky)
                    .font(.custom("Montserrat-Light", size: 25))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background (
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .foregroundColor(.mainPurple)
            )
        }
        .padding(.horizontal, 16)
    }
}

extension PurpleButtonView {
    func buttonTap() {
        if let actionPublisher = actionPublisher {
            actionPublisher.send()
        }
        if let action = action {
            action()
        }
    }
}

//#Preview {
//    PurpleButtonView()
//}
