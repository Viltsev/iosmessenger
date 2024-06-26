//
//  OnboardingView.swift
//  EnglishMessenger
//
//  Created by Данила on 01.03.2024.
//

import SwiftUI
import Combine

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel = OnboardingViewModel()
    @EnvironmentObject var viewModelTest: TestingViewModel
    @EnvironmentObject var router: StartNavigationRouter
    @State private var pageNumber = 0
    @State private var dateText = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        Color.lightPinky
            .ignoresSafeArea()
            .overlay {
                content()
                    .onAppear {
                        viewModel.input.fetchInterestSubject.send()
                    }
                    .onChange(of: inputImage) { _ in loadImage() }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        backButtonAction()
                    } label: {
                        Image("backButton")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
        
    }
}

extension OnboardingView {
    func imageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        return imageData.base64EncodedString(options: [])
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        //let image = Image(uiImage: inputImage)
        let base64String = imageToBase64(inputImage)
        if let base64String = base64String {
            viewModel.output.photo = base64String
        }
        //viewModel.output.image = image.uiImage()
    }
    
    func backButtonAction() {
        router.popView()
    }
    
    func goToTestingView() {
        viewModel.output.dateOfBirth = dateText
        viewModelTest.input.fetchTestDataSubject.send()
        viewModel.input.setupOnboardingSubject.send()
        router.pushView(StartNavigation.pushTestView)
    }
}

extension OnboardingView {
    
    @ViewBuilder
    func content() -> some View {
        VStack {
            TabView(selection: $pageNumber) {
                usernameView()
                    .tag(0)
                birthView()
                    .tag(1)
                photoView()
                    .tag(2)
                interestsView()
                    .tag(3)
                pretestView()
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
            OnboardingNavigationView(pageNumber: pageNumber)
        }
    }
    
    @ViewBuilder
    func usernameView() -> some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer()
            TitleTextView(text: "Введи username", size: 35)
            TextField("@", text: $viewModel.output.username)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 30))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func birthView() -> some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer()
            TitleTextView(text: "Твой День рождения", size: 30)
                .padding(.horizontal, 16)
            MaskedDateTextField(text: $dateText)
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func photoView() -> some View {
        VStack(alignment: .center, spacing: 25) {
            Spacer()
            TitleTextView(text: "Добавь фото", size: 35)
            Button {
                // todo: add photo action
                showingImagePicker.toggle()
            } label: {
                if let image = viewModel.output.image {
                    Image(uiImage: image)
                        .frame(width: 200, height: 200)
                        .overlay {
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundStyle(.mainPurple)
                                .frame(width: 200, height: 200)
                        }
                        .scaledToFit()
                } else {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(.mainPurple)
                        .frame(width: 200, height: 200)
                        .overlay {
                            Image("cameraImage")
                                .scaledToFit()
                        }
                }
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func interestsView() -> some View {
        VStack(alignment: .center, spacing: 25) {
            Spacer()
            TitleTextView(text: "Выбери интересующие тебя темы", size: 35)
                .padding(.horizontal, 16)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(viewModel.output.interestsArray, id: \.id) { interest in
                        Button {
                            viewModel.input.saveInterestIdSubject.send(interest.id)
                        } label: {
                            VStack {
                                Text(interest.interest)
                                    .font(.custom("Montserrat-Regular", size: 16))
                                    .foregroundStyle(
                                        interest.selection == .selected ? .pinky2 :
                                            interest.id % 2 == 0 ? Color.pinky2 : Color.lightPurple
                                    )
                                    .padding(.horizontal, 45)
                                    .padding(.vertical, 15)
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                interest.selection == .selected ? .mainPurple :
                                    interest.id % 2 == 0 ? Color.lightPurple : Color.pinky2
                            )
                            .clipShape(.buttonBorder)
                            .padding(.horizontal, 25)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func pretestView() -> some View {
        VStack(alignment: .center, spacing: 25) {
            Spacer()
            TitleTextView(text: "Давай проверим твой уровень английского", size: 35)
                .padding(.horizontal, 16)
            Image("bookTest")
                .scaledToFit()
            
            Spacer()
            Button {
                goToTestingView()
            } label: {
                VStack {
                    Text("Продолжить")
                        .font(.custom("Montserrat-Regular", size: 20))
                        .foregroundStyle(.mainPurple)
                        .padding(.horizontal, 100)
                        .padding(.vertical, 16)
                }
                .background (
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(.mainPurple)
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
//            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
