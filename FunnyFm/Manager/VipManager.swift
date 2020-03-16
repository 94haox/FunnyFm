//
//  VipManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class VipManager: NSObject {
    
    static let shared = VipManager()
    
    var isVip: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isPurchase")
        }
    }
    
}
