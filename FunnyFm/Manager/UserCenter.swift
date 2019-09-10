//
//  UserCenter.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/13.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class UserCenter: NSObject {
    
    static let shared = UserCenter()
	
    var userId: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
            UserDefaults.standard.synchronize()
        }
        get {
            let userId = UserDefaults.standard.string(forKey: "userId")
            if userId.isSome {
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
			if name.isSome {
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
			if avatar.isSome {
				return avatar!
			}
			return ""
		}
	}
	
	
	
    var isLogin : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
    }
    
    
    

}
