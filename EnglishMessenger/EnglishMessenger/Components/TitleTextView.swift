//
//  TitleTextView.swift
//  EnglishMessenger
//
//  Created by Данила on 01.03.2024.
//

import SwiftUI

struct TitleTextView: View {
    var text: String
    var size: CGFloat
    
    var body: some View {
        Text(text)
            .font(.custom("Alice-Regular", size: size))
            .foregroundStyle(.mainPurple)
    }
}

#Preview {
    TitleTextView(text: "Sign In", size: 40)
}
