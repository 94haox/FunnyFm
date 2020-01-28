//
//  LoginViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/7.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class LoginViewModel: BaseViewModel {
    var user: User?
    func login(mail: String, and pwd: String) {
		var params:[String : Any] = [:]
		params["mail"] = mail
		params["password"] = pwd
		params["type"] = "email"
		FmHttp<User>().requestForSingle(UserAPI.login(params), { (person) in
            if person.isSome {
                self.user = person
				UserCenter.shared.userId = person!.userId
				UserCenter.shared.name = person!.name
				UserCenter.shared.avatar = person!.avatar
                self.delegate?.viewModelDidGetDataSuccess()
            }
        }, { (message) in
            self.delegate?.viewModelDidGetDataFailture(msg: message)
        })
    }
    
    func register(mail: String, and pwd: String) {
		var params:[String : Any] = [:]
		params["mail"] = mail
		params["password"] = pwd
		params["type"] = "email"
		FmHttp<User>().requestForSingle(UserAPI.register(params), { (person) in
            if person.isSome {
                self.user = person
				UserCenter.shared.userId = person!.userId
				UserCenter.shared.name = person!.name
				UserCenter.shared.avatar = person!.avatar
                self.delegate?.viewModelDidGetDataSuccess()
            }
        }, { (message) in
            self.delegate?.viewModelDidGetDataFailture(msg: message)
        })
    }
	
	func login(googleData:[String: Any]) {
		FmHttp<User>().requestForSingle(UserAPI.login(googleData), { (person) in
			if person.isSome {
				self.user = person
				UserCenter.shared.isLogin = true
				UserCenter.shared.userId = person!.userId
				UserCenter.shared.name = person!.name
				UserCenter.shared.avatar = person!.avatar
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}, { (message) in
			self.delegate?.viewModelDidGetDataFailture(msg: message)
		})
	}
	
	func login(appleData:[String: Any]) {
		FmHttp<User>().requestForSingle(UserAPI.login(appleData), { (person) in
			if person.isSome {
				self.user = person
				UserCenter.shared.isLogin = true
				UserCenter.shared.userId = person!.userId
				UserCenter.shared.name = person!.name
				UserCenter.shared.avatar = person!.avatar
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}, { (message) in
			self.delegate?.viewModelDidGetDataFailture(msg: message)
		})
	}
	
    
}
