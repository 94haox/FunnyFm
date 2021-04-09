//
//  SignWithApple.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI
import AuthenticationServices

#if canImport(UIKit)
import UIKit

public typealias NSUIViewRepresentable = UIViewRepresentable

#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public typealias NSUIViewRepresentable = NSViewRepresentable

#endif

// 1
final class SignInWithApple: NSUIViewRepresentable {
    
    typealias NSViewType = ASAuthorizationAppleIDButton
    
    func makeNSView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }
    
    func updateNSView(_ nsView: ASAuthorizationAppleIDButton,
                      context: Context){}
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }
      
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton,
                      context: Context) {}
}
