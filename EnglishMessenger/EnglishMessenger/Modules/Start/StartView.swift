//
//  ContentView.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

struct StartView: View {
    @StateObject private var viewModel: StartViewModel = StartViewModel()
    @StateObject private var viewModelTest = TestingViewModel()
    @EnvironmentObject var router: StartNavigationRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Color.lightPinky
            .ignoresSafeArea()
            .overlay {
                content()
                    .navigationDestination(for: StartNavigation.self) { nav in
                        Group {
                            switch nav {
                            case .pushAuthorizationView:
                                AuthorizationView()
                            case .pushRegistrationView:
                                RegistrationView()
                            case .pushOnboardingView:
                                OnboardingView()
                                    .environmentObject(viewModelTest)
                            case .pushTestView:
                                TestingView()
                                    .environmentObject(viewModelTest)
                            case .pushTestResultsView:
                                TestResultsView()
                                    .environmentObject(viewModelTest)
                                
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(router)
                    }
            }
        }
        
    }
}

extension StartView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            HStack {
                Image("blueBlob")
                    .imageScale(.small)
                    
                Spacer()
            }
            Spacer()
            VStack(alignment: .leading) {
                Spacer()
                TitleTextView(text: "Communicate.\nLearn.\nEnglish.", size: 40)
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    ButtonView(text: "Sign In", buttonColor: .mainPurple, size: 35, action: regButtonAction)
                    ButtonView(text: "Sign Up", buttonColor: .lightPurple, size: 35, action: authButtonAction)
                }
            }
            Spacer()
            HStack {
                Spacer()
                Image("pinkBlob")
                    .imageScale(.small)
            }
        }
        .ignoresSafeArea()
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
