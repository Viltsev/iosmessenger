//
//  HomeView.swift
//  EnglishMessenger
//
//  Created by Данила on 06.03.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var activeTab: MainTab = .profile
    @State private var allTabs: [AnimatedTab] = MainTab.allCases.compactMap { tab ->
        AnimatedTab in
        return .init(tab: tab)
    }
    @EnvironmentObject var router: StartNavigationRouter
    @EnvironmentObject var mainRouter: MainNavigationRouter
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                ChatsStartView()
                    .setUpTab(.chats)
                    .environmentObject(mainRouter)
                ProfileView()
                    .setUpTab(.profile)
                    .environmentObject(router)
                Text("dictionary")
                    .setUpTab(.dictionary)
                Text("exercises")
                    .setUpTab(.exercises)
            }
            
            CustomTabBar()
        }
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .scaleEffect(activeTab == tab ? 1.25 : 1.0)
                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? .mainPurple : .lightPurple)
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        activeTab = tab
                    }
                }
            }
        }
        .background(.white)
    }
}

extension View {
    @ViewBuilder
    func setUpTab(_ tab: MainTab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    HomeView()
}
