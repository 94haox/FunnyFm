//
//  PushManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/3.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterPush
import AppCenterAnalytics
import AppCenterCrashes
import OneSignal
import UserNotifications


class PushManager: NSObject {
	var isUserTap = false
	
	func configureThridSDK(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
		
		MSAppCenter.start("f9778dd8-1385-462e-a4e1-fa37182cb200", withServices:[MSAnalytics.self,MSCrashes.self,MSPush.self])
		MSPush.setDelegate(self)
		UNUserNotificationCenter.current().delegate = self
		
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


extension PushManager : MSPushDelegate {
	
	func push(_ push: MSPush!, didReceive pushNotification: MSPushNotification!) {
		self.isUserTap = true
	}
	
}

extension PushManager : UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		MSPush.didReceiveRemoteNotification(notification.request.content.userInfo)
		completionHandler(UNNotificationPresentationOptions.badge);
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		self.isUserTap = true
		completionHandler()
	}
}
