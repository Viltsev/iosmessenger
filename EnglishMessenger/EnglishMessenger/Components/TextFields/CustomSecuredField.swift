//
//  CustomSecuredField.swift
//  EnglishMessenger
//
//  Created by Данила on 08.05.2024.
//

import SwiftUI
import Combine

struct CustomSecuredField: View {
    var textFieldLabel: String
    var text: Binding<String>
    var isSecured: Bool
    var action: PassthroughSubject<Void, Never>
    
    var body: some View {
        VStack(alignment: .leading) {
            if isSecured {
                SecureField(textFieldLabel, text: text)
                    .textFieldStyle(CustomSecuredFieldStyle(isSecured: isSecured, action: action))
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Light", size: 22))
            } else {
                TextField(textFieldLabel, text: text)
                    .textFieldStyle(CustomSecuredFieldStyle(isSecured: isSecured, action: action))
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Light", size: 22))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

