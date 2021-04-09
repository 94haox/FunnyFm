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
    
    @ObservedObject var viewModel = LoginViewModel()
    
    @State var isShowTerms: Bool = false
    
    @State var isShowPollicy: Bool = false
    
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
                Image(systemName: "bolt.horizontal.circle")
                    .imageScale(.large)
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                    .frame(width: 200, height: 200)
                Spacer()
            }
            HStack {
                Spacer()
                VStack {
                    SignInWithAppleButton { (request) in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { (result) in
                        viewModel.handle(result: result)
                    }.signInWithAppleButtonStyle(.black)
                }
                Spacer()
            }
            .padding(.bottom, 64)
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
