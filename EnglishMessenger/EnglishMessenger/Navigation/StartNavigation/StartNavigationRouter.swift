//
//  NavigationRouter.swift
//  EnglishMessenger
//
//  Created by Данила on 16.02.2024.
//

import SwiftUI

final class StartNavigationRouter: ObservableObject {
    
    @Published var path = NavigationPath() {
        didSet {
            print(path.count)
        }
    }
    
    func pushView<T: Hashable>(_ destination: T) {
        self.path.append(destination)
    }
    
    func popToRoot() {
        self.path = NavigationPath()
    }
    
    func popView() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
