//
//  PreferenceCenter.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/12.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class PreferenceCenter: NSObject {
	
	static let shared = PreferenceCenter()
	
	var isAutoSync : Bool {
		set {
			UserDefaults.standard.set(newValue, forKey: "isAutoSync\(UserCenter.shared.userId)")
			UserDefaults.standard.synchronize()
		}
		get {
			if UserCenter.shared.isLogin {
				return UserDefaults.standard.bool(forKey: "isAutoSync\(UserCenter.shared.userId)")
			}
			return false
		}
	}

}
