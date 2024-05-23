//
//  SignInWithEmailView.swift
//  BeatitudoMedia
//
//  Created by Jinho Lee on 5/20/24.
//

import SwiftUI

struct SignInWithEmailView: View {
    @StateObject private var viewModel = EmailSigningViewModel()
    
    @FocusState private var keyboardOut: Utils.EmailSigningFocusField?
    
    @Binding var showEmailSigningPage: Bool
    @Binding var isUserLoggedIn: Bool
    
    @State private var keyboardOffsetY: CGFloat = 0
    @State private var showProgressView: Bool   = false
    @State private var showPassword: Bool       = false
    
    var body: some View {
        if showEmailSigningPage {
            NavigationStack {
                ZStack {
                    BeatitudoMediaProgressView()
                        .opacity(showProgressView ? 1 : 0)
                        .zIndex(1)
                    
                    Color.adaptiveBackground
                        .onTapGesture {
                            keyboardOut = nil
                        }
                    
                    VStack {
                        Spacer()
                            .frame(height: 45)
                        
                        HStack {
                            Button {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    showEmailSigningPage = false
                                    keyboardOut = nil
                                    keyboardOffsetY = 0
                                    viewModel.reset()
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.adaptiveView)
                            }
                            
                            Spacer()
                        }
                        .frame(height: 40)
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    VStack(alignment: .leading) {
                        Text("안녕하세요.")
                            .font(.system(size: 30))
                            .bold()
                            .padding(.top, 25)
                        
                        Text("쉼 터 Beatitudo Media에 다시 방문하신 것을 환영합니다.")
                            .padding(.bottom, 25)
                        
                        VStack(alignment: .leading) {
                            TextField("이메일 주소를 입력해주세요.", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .padding()
                                .background(Color.gray.opacity(0.4))
                                .clipShapeAndStrokeBorderWithRoundedRectangle(cornerRadius: 25, borderColor: viewModel.isValidEmail ? .clear : .red)
                                .focused($keyboardOut, equals: .email)
                                .textInputAutocapitalization(.never)
                                .frame(height: 55)
                            
                            Text("올바른 이메일 주소를 입력해주세요.")
                                .opacity(viewModel.isValidEmail ? 0 : 1)
                                .font(.system(size: 12))
                                .foregroundStyle(.red)
                                .padding(.leading, 5)
                        }
                        
                        VStack(alignment: .leading) {
                            ZStack(alignment: .trailing) {
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundStyle(.gray.opacity(0.4))
                                    .clipShapeAndStrokeBorderWithRoundedRectangle(cornerRadius: 25, borderColor: viewModel.isValidPassword ?  .clear : .red)
                                
                                SecureField("비밀번호를 입력해주세요.", text: $viewModel.password)
                                    .padding()
                                    .focused($keyboardOut, equals: .passwordHidden)
                                    .textInputAutocapitalization(.never)
                                    .opacity(showPassword ? 0 : 1)
                                
                                TextField("비밀번호를 입력해주세요.", text: $viewModel.password)
                                    .padding()
                                    .focused($keyboardOut, equals: .passwordShown)
                                    .textInputAutocapitalization(.never)
                                    .opacity(showPassword ? 1 : 0)
                                
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.adaptiveView)
                                    .padding(.trailing, 10)
                                    .onTapGesture {
                                        showPassword.toggle()
                                        if keyboardOut != nil {
                                            if keyboardOut == .passwordHidden {
                                                keyboardOut = .passwordShown
                                            } else {
                                                keyboardOut = .passwordHidden
                                            }
                                        }
                                    }
                            }
                            .frame(height: 55)
                            
                            Text("비밀번호는 6자 이상으로 입력해주세요.")
                                .opacity(viewModel.isValidPassword ? 0 : 1)
                                .font(.system(size: 12))
                                .foregroundStyle(.red)
                                .padding(.leading, 5)
                        }
                        
                        Button {
                            keyboardOut = nil
                            Task {
                                do {
                                    showProgressView = true
                                    try await viewModel.signIn()
                                    isUserLoggedIn = GlobalAssets.isUserLoggedIn
                                    showProgressView = false
                                } catch let error {
                                    showProgressView = false
                                }
                            }
                        } label: {
                            Text("로그인하기")
                                .font(.headline)
                                .foregroundStyle(.adaptiveBackground)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(.adaptiveView)
                                .clipShape( RoundedRectangle(cornerRadius: 25) )
                        }
                        .disabled((!viewModel.isValidEmail || !viewModel.isValidPassword) || (viewModel.email.isEmpty || viewModel.password.isEmpty))
                    }
                    .padding()
                    .offset(y: keyboardOffsetY)
                }
                .onChange(of: keyboardOut) { _, _ in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        keyboardOffsetY = keyboardOut != nil ? -200 : 0
                    }
                }
            }
            .onChange(of: isUserLoggedIn) { _, newValue in
                if newValue == true {
                    showEmailSigningPage = false
                    keyboardOut = nil
                }
            }
            .transition(.move(edge: .bottom))
        }
    }
}
