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
        content(username: viewModel.output.username,
                dateBirth: viewModel.output.dateBirth,
                languageLevel: viewModel.output.languageLevel)
    }
}

extension ProfileView {
    
    @ViewBuilder
    func content(username: String, dateBirth: String, languageLevel: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button {
                    viewModel.input.logoutSubject.send()
                } label: {
                    Text("Logout")
                        .font(.headline)
                        .fontDesign(.serif)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            HStack {
                Circle()
                    .frame(height: 130)
                    .foregroundStyle(Color.indigo)
                    .padding(.leading, 16)
                    .padding(.top, 25)
                //                Image(uiImage: viewModel.output.photo)
                //                    .frame(width: 30, height: 30)
                //                    .scaledToFill()
                //                    .padding(.leading, 16)
                //                    .padding(.top, 25)
                Spacer()
                VStack(alignment: .leading) {
                    Text(username)
                        .font(.title)
                        .fontDesign(.serif)
                        .foregroundStyle(.black)
                        .padding(.horizontal)
                    Divider()
                        .background(Color.black)
                        .padding(.trailing, 16)
                        .padding(.bottom, 10)
                    HStack {
                        Text("\(dateBirth),   \(languageLevel)")
                            .font(.title3)
                            .fontDesign(.serif)
                            .foregroundStyle(.gray)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 30)
            }
            // friendsBlock()
            Spacer()
        }
    }
    
    @ViewBuilder
    func friendsBlock() -> some View {
        Button {
            
        } label: {
            HStack {
                Text("146 друзей")
                    .font(.title3)
                    .fontDesign(.serif)
                    .foregroundStyle(.black)
                    .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(.buttonBorder)
            .shadow(color: .gray, radius: 3)
            .padding([.horizontal, .top], 25)
        }
    }
}

#Preview {
    ProfileView()
}
