//
//  CustomTextField.swift
//  EnglishMessenger
//
//  Created by Данила on 01.03.2024.
//

import SwiftUI

struct CustomTextField: View {
    var textFieldLabel: String
    var text: Binding<String>
    var isSecured: Bool?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let isSecured = isSecured {
                if isSecured {
                    SecureField(textFieldLabel, text: text)
                        .textFieldStyle(CustomTextFieldStyle())
                        .foregroundColor(.mainPurple)
                        .font(.custom("Montserrat-Light", size: 22))
                } else {
                    TextField(textFieldLabel, text: text)
                        .textFieldStyle(CustomTextFieldStyle())
                        .foregroundColor(.mainPurple)
                        .font(.custom("Montserrat-Light", size: 22))
                }
            } else {
                TextField(textFieldLabel, text: text)
                    .textFieldStyle(CustomTextFieldStyle())
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Light", size: 22))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

//#Preview {
//    CustomTextField()
//}
