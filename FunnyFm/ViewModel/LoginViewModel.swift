//
//  LoginViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/7.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class LoginViewModel: BaseViewModel {

    func login(mail: String, and pwd: String) {
        FmHttp<User>().requestForSingle(UserAPI.login(mail, pwd), success: { (person) in
            if person.isSome {
                self.delegate?.viewModelDidGetDataSuccess()
            }
        }, { (message) in
            self.delegate?.viewModelDidGetDataFailture(msg: message)
        })
    }
    
    func register(mail: String, and pwd: String) {
        FmHttp<User>().requestForSingle(UserAPI.register(mail, pwd), success: { (person) in
            if person.isSome {
                self.delegate?.viewModelDidGetDataSuccess()
            }
        }, { (message) in
            self.delegate?.viewModelDidGetDataFailture(msg: message)
        })
    }
    
}
