//
//  ContentView.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

struct StartView: View {
    @StateObject private var viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        content()
    }
}

extension StartView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            ButtonView(text: "Регистрация", buttonColor: .indigo, textColor: .white, actionPublisher: viewModel.input.pushRegistrationSubject)
            ButtonView(text: "Авторизация", buttonColor: .indigo, textColor: .white, actionPublisher: viewModel.input.pushAuthSubject)
        }
        .padding()
    }
}

#Preview {
    StartView()
}
