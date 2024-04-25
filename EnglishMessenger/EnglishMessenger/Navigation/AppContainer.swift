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
    @StateObject private var cardViewModel: CardViewModel = CardViewModel()
    @StateObject private var cardsSetViewModel: CardsSetViewModel = CardsSetViewModel()
    
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
                                case .pushCardsSets:
                                    CardsSetsView()
                                case .pushCardsSet(let set):
                                    CardsSetView(viewModel: cardsSetViewModel)
                                        .onAppear {
                                            cardsSetViewModel.output.cardSet = set
                                        }
                                case .pushCardView(let cardArray):
                                    CardView(viewModel: cardViewModel)
                                        .onAppear {
                                            print("card array : \(cardArray)")
                                            cardViewModel.output.cards = cardArray
                                        }
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
