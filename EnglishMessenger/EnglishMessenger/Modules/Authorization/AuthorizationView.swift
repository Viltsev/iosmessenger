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
            .ignoresSafeArea(.keyboard)
    }
}

extension AuthorizationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
        
            CustomTextField(textFieldLabel: "Почта...", text: $viewModel.output.emailField)
                .onChange(of: viewModel.output.emailField, emailAction)
            
            CustomSecuredField(textFieldLabel: "Пароль...", text: $viewModel.output.passwordField, isSecured: viewModel.output.isSecured, action: viewModel.input.showPasswordSubject)
                .onChange(of: viewModel.output.passwordField, passwordAction)
            
            button()
            
            Spacer()
            
            Image("hedgehog2")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .cornerRadius(125)
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
            Text("Авторизация")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 24))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
}

extension AuthorizationView {
    @ViewBuilder
    func button() -> some View {
        ButtonView(text: "Войти в аккаунт", buttonColor: .mainPurple, size: 30, actionPublisher: viewModel.input.authUserSubject)
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
