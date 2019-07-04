//
//  PushManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/3.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import OneSignal


class PushManager: NSObject {
	
	func configurePushSDK(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
		
		let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false,kOSSettingsKeyInAppLaunchURL: true]
		
		// 前台时接受到通知
		let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
			print("Received Notification: \(String(describing: notification!.payload.notificationID))")
		}
		
		// 用户点击通知时回调
		let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
			let payload: OSNotificationPayload = result!.notification.payload
			if payload.additionalData != nil {
				
			}
		}
		
		OneSignal.initWithLaunchOptions(launchOptions,
										appId: "30cd881e-c916-44d2-8293-b2f7e2c7deae",
										handleNotificationReceived: notificationReceivedBlock,
										handleNotificationAction: notificationOpenedBlock,
										settings: onesignalInitSettings)
		
		OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
		
		OneSignal.promptForPushNotifications(userResponse: { accepted in
			print("User accepted notifications: \(accepted)")
		})
		
		
		
	}
	
	
	
}
