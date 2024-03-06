//
//  ProfileView.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                profileBlock()
            }
    }
}

extension ProfileView {
    @ViewBuilder
    func profileBlock() -> some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                VStack {
                    Image("profileEllipse")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .overlay {
                            VStack {
                                Spacer()
                                HStack {
                                    profileButton(title: "Settings", action: nil)
                                    Spacer()
                                    profileButton(title: "Sign Out", action: logout)
                                }
                                .padding(.horizontal, 16)
                                GeometryReader { geometry in
                                    Circle()
                                        .foregroundColor(.blue)
                                        .frame(width: 200)
                                        .background(
                                            Circle()
                                                .stroke(style: StrokeStyle(lineWidth: 2))
                                                .foregroundColor(.white)
                                        )
                                        .offset(x: geometry.size.width / 4, y: 40)
                                }
                            }
                        }
                    VStack(spacing: 15) {
                        HStack {
                            Text("Danila")
                                .foregroundColor(.black)
                                .font(.custom("Montserrat-Regular", size: 35))
                            Text("Viltsev")
                                .foregroundColor(.black)
                                .font(.custom("Montserrat-Regular", size: 35))
                        }
                        Text("@viltsev")
                            .foregroundColor(.mainPurple)
                            .font(.custom("Montserrat-Light", size: 20))
                            .multilineTextAlignment(.center)
                        ScrollView {
                            VStack(spacing: 15) {
                                infoBlock(text: "Birthday:", value: "24.12.2001", arrow: false)
                                infoBlock(text: "Language level:", value: "B2", arrow: false)
                                infoBlock(text: "Friends:", value: "100", arrow: true)
                                infoBlock(text: "Interests", value: "", arrow: true)
                            }
                        }
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
        
    }
    
    @ViewBuilder
    func infoBlock(text: String, value: String, arrow: Bool) -> some View {
        HStack {
            Text("\(text) \(value)")
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 15))
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
            Spacer()
            if arrow {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func profileButton(title: String, action: (() -> Void)?) -> some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            Text(title)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 15))
        }
    }
}

extension ProfileView {
    func logout() {
        viewModel.input.logoutSubject.send()
    }
}

#Preview {
    ProfileView()
}
