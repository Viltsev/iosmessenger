//
//  AppContainer.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

struct AppContainer: View {
    @StateObject var router = StartNavigationRouter()
    @State private var isAuth = AuthenticationService.shared.status.value
    
    
    var body: some View {
        Group {
            if isAuth {
                ProfileView()
            } else {       
                // TestResultsView()
                StartView()
                    .environmentObject(router)
            }
        }
        .onReceive(AuthenticationService.shared.status) { status in
            isAuth = status
        }
    }
}

#Preview {
    AppContainer()
}
