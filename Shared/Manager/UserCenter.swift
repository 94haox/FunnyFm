//
//  UserCenter.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/13.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import SwiftUI

class UserCenter: NSObject, ObservableObject {
    
    static let shared = UserCenter()
	
    @Published var isLoginStatus = false
    
    var userId: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
            UserDefaults.standard.synchronize()
        }
        get {
            let userId = UserDefaults.standard.string(forKey: "userId")
            if userId != nil {
                return userId!
            }
            return ""
        }
    }
	
	var name: String {
		set {
			UserDefaults.standard.set(newValue, forKey: "name")
			UserDefaults.standard.synchronize()
		}
		get {
			let name = UserDefaults.standard.string(forKey: "name")
			if name != nil {
				return name!
			}
			return ""
		}
	}
	
	var avatar: String {
		set {
			UserDefaults.standard.set(newValue, forKey: "avatar")
			UserDefaults.standard.synchronize()
		}
		get {
			let avatar = UserDefaults.standard.string(forKey: "avatar")
			if avatar != nil {
				return avatar!
			}
			return ""
		}
	}
	
    var isLogin : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
            UserDefaults.standard.synchronize()
            isLoginStatus = newValue
        }
        get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
    }
}
