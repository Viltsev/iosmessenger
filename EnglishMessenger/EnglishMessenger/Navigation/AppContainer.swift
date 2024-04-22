//
//  AppContainer.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

struct AppContainer: View {
    @StateObject var router = StartNavigationRouter()
    @StateObject var mainRouter = MainNavigationRouter()
    
    @State private var isAuth = AuthenticationService.shared.status.value
    
    
    var body: some View {
        Group {
            if isAuth {
                NavigationStack(path: $mainRouter.path) {
                    HomeView()
                        .environmentObject(mainRouter)
                        .navigationDestination(for: MainNavigation.self) { nav in
                            Group {
                                switch nav {
                                case .pushChatView(let user):
                                    ChatsView(user: user)
                                case .pushCardsView:
                                    CardsView()
                                case .pushCardsLearned:
                                    CardsLearnedView()
                                case .pushCardsLearning:
                                    CardsLearningView()
                                }
                            }
                            .navigationBarBackButtonHidden(true)
                            .environmentObject(mainRouter)
                        }
                }
            } else {
                StartView()
            }
        }
        .environmentObject(router)
        .onReceive(AuthenticationService.shared.status) { status in
            isAuth = status
        }
    }
}

#Preview {
    AppContainer()
}
