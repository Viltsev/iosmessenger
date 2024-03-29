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

extension RegistrationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            TitleTextView(text: "Sign In", size: 40)
            
            Image("foxImage")
                .imageScale(.medium)
            
            Spacer()
            
            CustomTextField(textFieldLabel: "First Name", text: $viewModel.output.firstNameFieldText)
                .onChange(of: viewModel.output.firstNameFieldText, firstNameAction)
            CustomTextField(textFieldLabel: "Last Name", text: $viewModel.output.lastNameFieldText)
                .onChange(of: viewModel.output.lastNameFieldText, lastNameAction)
            CustomTextField(textFieldLabel: "Email", text: $viewModel.output.emailFieldText)
                .onChange(of: viewModel.output.emailFieldText, emailAction)
            CustomTextField(textFieldLabel: "Password", text: $viewModel.output.passwordFieldText)
                .onChange(of: viewModel.output.passwordFieldText, passwordAction)
            button()
        }
        .padding()
    }
}

extension RegistrationView {
    @ViewBuilder
    func button() -> some View {
        ButtonView(text: "Create an account", buttonColor: .mainPurple, size: 30, action: goToOnboarding)
            .padding(.vertical, 20)
            .disabled(viewModel.output.isEnabledButton)
    }
}

extension RegistrationView {
    func goToOnboarding() {
        viewModel.input.registerUserSubject.send()
        router.pushView(StartNavigation.pushOnboardingView)
    }
    
    func backButtonAction() {
        router.popView()
    }
    
    func firstNameAction() {
        viewModel.input.firstNameSubject.send()
    }
    
    func lastNameAction() {
        viewModel.input.lastNameSubject.send()
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
