//
//  AppContainer.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

struct AppContainer: View {
    @StateObject var router = StartNavigationRouter()
    
    var body: some View {
        StartView()
            .environmentObject(router)
    }
}

#Preview {
    AppContainer()
}
