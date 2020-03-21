//
//  PrivacyManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/4.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import UserNotifications

let ff_isConfigANPS = "ff_isConfigANPS"

class PrivacyManager: NSObject {
    
    static var isConfigAPNS: Bool {
        UserDefaults.standard.bool(forKey: ff_isConfigANPS)
    }
    
    /// 是否开启推送
    static func isOpenPusn() -> Bool{
        return UIApplication.shared.currentUserNotificationSettings?.types.rawValue != 0
    }
    

}
