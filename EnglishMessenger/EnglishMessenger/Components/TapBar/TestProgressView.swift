//
//  TestNavigationView.swift
//  EnglishMessenger
//
//  Created by Данила on 02.03.2024.
//

import SwiftUI

struct TestProgressView: View {
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
          ZStack(alignment: .leading) {
              RoundedRectangle(cornerSize: .init(width: 25, height: 25))
                  .frame(width: geometry.size.width, height: 17)
                  .opacity(0.3)
                  .foregroundColor(.gray)

              RoundedRectangle(cornerSize: .init(width: 25, height: 25))
                  .frame(
                    width: min(progress * geometry.size.width,
                               geometry.size.width),
                    height: 17
                  )
                  .foregroundColor(.mainPurple)
          }
        }
    }
}

//#Preview {
//    TestProgressView()
//}
