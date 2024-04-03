//
//  ScaleButtonStyle.swift
//  EnglishMessenger
//
//  Created by Данила on 03.04.2024.
//

import Foundation
import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.04 : 1)
    }
}
