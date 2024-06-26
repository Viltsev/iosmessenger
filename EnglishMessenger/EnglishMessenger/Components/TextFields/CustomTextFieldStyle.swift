//
//  CustomTextFieldStyle.swift
//  EnglishMessenger
//
//  Created by Данила on 01.03.2024.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(.lightPinky)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.lightPurple, lineWidth: 1)
            )
    }
}
