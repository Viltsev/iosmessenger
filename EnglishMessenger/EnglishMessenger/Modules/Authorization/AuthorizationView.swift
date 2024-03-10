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
        Color.lightPinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        backButtonAction()
                    } label: {
                        Image("backButton")
                            .imageScale(.large)
                    }
                }
            }
    }
}

extension AuthorizationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            TitleTextView(text: "Sign Up", size: 40)
                .padding(.bottom, 30)
            
            Image("koalaImage")
                .imageScale(.large)
            
            Spacer()
            
            CustomTextField(textFieldLabel: "Email", text: $viewModel.output.emailField)
                .onChange(of: viewModel.output.emailField, emailAction)
            
            CustomTextField(textFieldLabel: "Password", text: $viewModel.output.passwordField)
                .onChange(of: viewModel.output.passwordField, passwordAction)
            
            Spacer()
            
            button()
        }
        .padding()
    }
}

extension AuthorizationView {
    @ViewBuilder
    func button() -> some View {
        ButtonView(text: "Login to account", buttonColor: .mainPurple, size: 30, actionPublisher: viewModel.input.authUserSubject)
            .padding(.vertical, 20)
            .disabled(viewModel.output.isEnabledButton)
    }
}

extension AuthorizationView {
    func backButtonAction() {
        router.popToRoot()
    }
    
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
