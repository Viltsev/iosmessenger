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
            .ignoresSafeArea(.keyboard)
    }
}

extension RegistrationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
            
            CustomTextField(textFieldLabel: "Имя...", text: $viewModel.output.firstNameFieldText)
                .onChange(of: viewModel.output.firstNameFieldText, firstNameAction)
            CustomTextField(textFieldLabel: "Фамилия...", text: $viewModel.output.lastNameFieldText)
                .onChange(of: viewModel.output.lastNameFieldText, lastNameAction)
            CustomTextField(textFieldLabel: "Почта...", text: $viewModel.output.emailFieldText)
                .onChange(of: viewModel.output.emailFieldText, emailAction)
            CustomSecuredField(textFieldLabel: "Пароль", text: $viewModel.output.passwordFieldText, isSecured: viewModel.output.isSecured, action: viewModel.input.showPasswordSubject)
                .onChange(of: viewModel.output.passwordFieldText, passwordAction)
            button()
            
            Spacer()
            
            Image("hedgehog")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .padding(.vertical, 25)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func customToolBar() -> some View {
        HStack {
            Button {
                router.popView()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.mainPurple)
                    .font(.title3)
                    .bold()
            }
            Spacer()
            Text("Регистрация")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 24))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
}

extension RegistrationView {
    @ViewBuilder
    func button() -> some View {
        ButtonView(text: "Создать аккаунт", buttonColor: .mainPurple, size: 30, action: goToOnboarding)
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
