//
//  LoginViewModel.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import SwiftUI
import AuthenticationServices

class LoginViewModel: NSObject, ObservableObject {
    
    @Published var errorMsg: String?
    
    @Published var loginSuccessd: Bool = false
    
    func handle(result: Result<ASAuthorization, Error>) {
        switch result {
            case .success(let authorization):
                guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                    return
                }
                var params:[String : Any] = ["type": "apple"]
                params["apple_userid"] = appleIDCredential.user
                if let identityToken = appleIDCredential.identityToken {
                    params["apple_token"] = String(data: identityToken, encoding: .utf8)
                }

                if let fullName = appleIDCredential.fullName {
                    if let givenName = fullName.givenName,
                       let familyName = fullName.familyName {
                        params["name"] = givenName + familyName
                    } else {
                        params["name"] = fullName.nickname ?? ""
                    }
                }
                self.login(appleData: params)
            default:
                return
        }
    }
    
    func login(appleData:[String: Any]) {
        FmHttp<User>().requestForSingle(UserAPI.login(appleData), { (person) in
            guard let person = person else {
                self.errorMsg = "Login Failed"
                return
            }
            UserCenter.shared.isLogin = true
            UserCenter.shared.userId = person.userId
            UserCenter.shared.name = person.name
            UserCenter.shared.avatar = person.avatar
        }, { (message) in
            self.errorMsg = message
        })
    }
}

