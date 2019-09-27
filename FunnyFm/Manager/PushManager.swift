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
	
	static let shared = PushManager.init()
	
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
				if payload.additionalData["type"] as! String == "podcast" {
					NotificationCenter.default.post(name: Notification.podcastUpdateNewEpisode, object: nil, userInfo: payload.additionalData)
				}
				
				if payload.additionalData["type"] as! String == "appUpdate" {
					NotificationCenter.default.post(name: Notification.appHasNewVersionReleased, object: nil, userInfo: nil)
				}
			}
		}
		
		OneSignal.initWithLaunchOptions(launchOptions,
										appId: onesignalKey,
										handleNotificationReceived: notificationReceivedBlock,
										handleNotificationAction: notificationOpenedBlock,
										settings: onesignalInitSettings)
		
		OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
		
		OneSignal.promptForPushNotifications(userResponse: { accepted in
			print("User accepted notifications: \(accepted)")
		})
		
		let infoDic = Bundle.main.infoDictionary
		let appVersion = infoDic?["CFBundleShortVersionString"] as! String
		self.addTag(taglist: ["appVersion":appVersion])
		
	}
	
	func removeAllTages(){
		OneSignal.getTags { (tags) in
			var tagKeys = [Any]()
			guard let _ = tags else{
				return
			}
			
			tags!.forEach({ (keyPair) in
				tagKeys.append(keyPair.key)
			})
			
			OneSignal.deleteTags(tagKeys)
		}
	}
	
	func removeTags(tags: [String]){
		OneSignal.deleteTags(tags)
	}
	
	func addTag(taglist: [AnyHashable: Any]) {
		OneSignal.sendTags(taglist, onSuccess: { (taglist) in
			
		}) { (error) in
			if let cError = error {
				print("onesignaltag",cError.localizedDescription)
			}
		}
	}
	
	
	
}
