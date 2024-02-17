//
//  RegistrationView.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel = RegistrationViewModel()
    @EnvironmentObject var router: StartNavigationRouter
    
    var body: some View {
        content()
    }
}

extension RegistrationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            registrationField(title: "Username",
                              textFieldLabel: "Enter your username",
                              text: $viewModel.output.userNameFieldText)
            .onChange(of: viewModel.output.userNameFieldText, usernameAction)
            registrationField(title: "Email",
                              textFieldLabel: "Enter your email",
                              text: $viewModel.output.emailFieldText)
            .onChange(of: viewModel.output.emailFieldText, emailAction)
            registrationField(title: "Password",
                              textFieldLabel: "Enter your password",
                              text: $viewModel.output.passwordFieldText)
            .onChange(of: viewModel.output.passwordFieldText, passwordAction)
            button()
        }
        .padding()
    }
}

extension RegistrationView {
    @ViewBuilder
    func registrationField(title: String, textFieldLabel: String, text: Binding<String>) -> some View {
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
    
    @ViewBuilder
    func button() -> some View {
        ButtonView(text: "Зарегистрироваться", buttonColor: .indigo, textColor: .white, actionPublisher: viewModel.input.registerUserSubject)
            .padding(.vertical, 20)
            .disabled(viewModel.output.isEnabledButton)
    }
}

extension RegistrationView {
    func usernameAction() {
        viewModel.input.usernameSubject.send()
    }
    
    func emailAction() {
        viewModel.input.emailSubject.send()
    }
    
    func passwordAction() {
        viewModel.input.passwordSubject.send()
    }
}

#Preview {
    RegistrationView()
}
