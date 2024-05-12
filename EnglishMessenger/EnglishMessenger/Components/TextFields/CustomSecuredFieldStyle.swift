//
//  CustomSecuredFieldStyle.swift
//  EnglishMessenger
//
//  Created by Данила on 08.05.2024.
//

import SwiftUI
import Combine

struct CustomSecuredFieldStyle: TextFieldStyle {
    var isSecured: Bool
    var action: PassthroughSubject<Void, Never>
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            configuration
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(.lightPinky)
                .cornerRadius(15)
            Button {
                action.send()
            } label: {
                Image(systemName: isSecured ? "eye.fill" : "eye.slash.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .padding(.vertical, 10)
                    .padding(.trailing, 16)
            }
            .buttonStyle(.plain)
            
        }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.lightPurple, lineWidth: 1)
            )
    }
}
