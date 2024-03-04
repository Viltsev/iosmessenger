//
//  PurpleButtonView.swift
//  EnglishMessenger
//
//  Created by Данила on 03.03.2024.
//

import SwiftUI

struct PurpleButtonView: View {
    let text: String
    
    var body: some View {
        Button {
            
        } label: {
            VStack {
                Text(text)
                    .foregroundColor(.lightPinky)
                    .font(.custom("Montserrat-Light", size: 25))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background (
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .foregroundColor(.mainPurple)
            )
        }
        .padding(.horizontal, 16)
    }
}

//#Preview {
//    PurpleButtonView()
//}
