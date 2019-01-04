//
//  PrivacyManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/4.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import UserNotifications

class PrivacyManager: NSObject {
    
    /// 是否开启推送
    static func isOpenPusn() -> Bool{
        return UIApplication.shared.currentUserNotificationSettings?.types.rawValue != 0
    }
    

}
