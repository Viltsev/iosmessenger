//
//  AuthorizationView.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

struct AuthorizationView: View {
    @StateObject private var viewModel: AuthorizationViewModel = AuthorizationViewModel()
    @EnvironmentObject var router: StartNavigationRouter
    var body: some View {
        content()
    }
}

extension AuthorizationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            authField(title: "Email", textFieldLabel: "Enter your email", text: $viewModel.output.emailField)
                .onChange(of: viewModel.output.emailField, emailAction)
            authField(title: "Password", textFieldLabel: "Enter your password", text: $viewModel.output.passwordField)
                .onChange(of: viewModel.output.passwordField, passwordAction)
            button()
        }
        .padding()
    }
}

extension AuthorizationView {
    @ViewBuilder
    func authField(title: String, textFieldLabel: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontDesign(.serif)
                .foregroundStyle(.black)
            TextField(textFieldLabel, text: text)
                .textFieldStyle(.roundedBorder)
        }
        .padding([.horizontal, .vertical], 16)
    }
}

extension AuthorizationView {
    @ViewBuilder
    func button() -> some View {
        ButtonView(text: "Войти в аккаунт", buttonColor: .indigo, textColor: .white, actionPublisher: viewModel.input.authUserSubject)
            .padding(.vertical, 20)
            .disabled(viewModel.output.isEnabledButton)
    }
}

extension AuthorizationView {
    func emailAction() {
        viewModel.input.emailSubject.send()
    }
    
    func passwordAction() {
        viewModel.input.passwordSubject.send()
    }
}

#Preview {
    AuthorizationView()
}
