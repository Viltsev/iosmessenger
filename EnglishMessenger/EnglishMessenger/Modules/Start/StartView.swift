//
//  ContentView.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

struct StartView: View {
    @StateObject private var viewModel: StartViewModel = StartViewModel()
    @EnvironmentObject var router: StartNavigationRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: StartNavigation.self) { nav in
                    Group {
                        switch nav {
                        case .pushAuthorizationView:
                            AuthorizationView()
                        case .pushRegistrationView:
                            RegistrationView()
                        }
                    }
                    .environmentObject(router)
                }
        }
        
    }
}

extension StartView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            ButtonView(text: "Регистрация", buttonColor: .indigo, textColor: .white, action: regButtonAction)
            ButtonView(text: "Авторизация", buttonColor: .indigo, textColor: .white, action: authButtonAction)
        }
        .padding()
    }
}

extension StartView {
    func regButtonAction() {
        router.pushView(StartNavigation.pushRegistrationView)
    }
    
    func authButtonAction() {
        router.pushView(StartNavigation.pushAuthorizationView)
    }
}

#Preview {
    StartView()
}
