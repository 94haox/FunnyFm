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
    
    var isLogin : Bool {
//        return UserDefaults.standard.bool(forKey: "isLogin")
        set {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
    }
    
    
    

}
