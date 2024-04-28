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
    @StateObject private var theoryViewModel: TheoryMainViewModel = TheoryMainViewModel()
    @StateObject private var theoryTopicsViewModel: TheoryTopicsViewModel = TheoryTopicsViewModel()
    
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
                                            cardsSetViewModel.output.cardList = set.cardList
                                        }
                                case .pushCardView(let id):
                                    CardView(viewModel: cardViewModel)
                                        .onAppear {
                                            cardViewModel.output.setId = id
                                            cardViewModel.input.getCardSetSubject.send(id)
                                        }
                                case .pushTheoryMainView:
                                    TheoryMainView(viewModel: theoryViewModel)
                                        .onAppear {
                                            theoryViewModel.input.getTheorySubject.send()
                                        }
                                case .pushTheoryTopicsView(let category):
                                    TheoryTopicsView(viewModel: theoryTopicsViewModel)
                                        .onAppear {
                                            theoryTopicsViewModel.output.theory = category
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
