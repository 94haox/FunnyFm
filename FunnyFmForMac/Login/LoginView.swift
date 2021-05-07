//
//  LoginView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @ObservedObject var viewModel = GeneralLoginViewModel()
    
    @State var isShowTerms: Bool = false
    
    @State var isShowPollicy: Bool = false
    
    @State var isLoading: Bool = false
    
    var body: some View {
        List {
            HStack {
                Image(systemName: "person.2.fill")
                    .padding(.trailing, 5)
                Text("Welcome FunnyFm")
            }
            .font(.headline)
            HStack {
                Spacer()
                Image("logo-white")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 100, height: 100)
                    .cornerRadius(25)
                Spacer()
            }
            HStack {
                Spacer()
                VStack {
                    if !self.isLoading {
                        SignInWithAppleButton { (request) in
                            request.requestedScopes = [.fullName, .email]
                            isLoading = true
                        } onCompletion: { (result) in
                            viewModel.handle(result: result)
                        }.signInWithAppleButtonStyle(.black)
                    } else {
                        Indicator(shown: $isLoading)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 32)
            HStack {
                Spacer()
                Label("Terms of Service", systemImage: "t.square.fill")
                    .onTapGesture {
                        isShowTerms = true
                    }
                    .sheet(isPresented: $isShowTerms) {
                        TermView()
                            .frame(width: 500, height: 400)
                            .toolbar {
                                Label("确认", systemImage: "xmark.circle")
                                    .onTapGesture(perform: close)
                            }
                    }
                    .padding(.trailing, 32)
                Label("Privacy Policy", systemImage: "p.square.fill")
                    .onTapGesture {
                        isShowPollicy = true
                    }
                    .sheet(isPresented: $isShowPollicy) {
                        PolicyView()
                            .frame(width: 500, height: 400)
                            .toolbar {
                                Label("确认", systemImage: "xmark.circle")
                                    .onTapGesture(perform: close)
                            }
                    }
                Spacer()
            }
        }
    }
    
    private func close() {
        isShowPollicy = false
        isShowTerms = false
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
