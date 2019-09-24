//
//  JPushManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/24.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation



class JPushManager: NSObject {
	
	static let shared = JPushManager()
	
	func register(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
		let entity = JPUSHRegisterEntity.init()
		entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue|JPAuthorizationOptions.providesAppNotificationSettings.rawValue);
		JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
		JPUSHService.setup(withOption: launchOptions, appKey: "", channel: "", apsForProduction: true)
	}
	
	
}

extension JPushManager: JPUSHRegisterDelegate {

	
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
		if(notification.request.trigger! is UNPushNotificationTrigger ) {
			JPUSHService.handleRemoteNotification(notification.request.content.userInfo)
		 }
		completionHandler(2)
	}
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
		let userInfo = response.notification.request.content.userInfo;
		if(response.notification.request.trigger! is UNPushNotificationTrigger ) {
		  JPUSHService.handleRemoteNotification(userInfo)
		}
		completionHandler();
	}
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
		if (notification != nil) && notification.request.trigger! is UNPushNotificationTrigger {
			
		}else{
			
		}
	}
	
	
	
	
}


extension AppDelegate {
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		JPUSHService.registerDeviceToken(deviceToken)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		JPUSHService.handleRemoteNotification(userInfo)
		completionHandler(UIBackgroundFetchResult.newData)
	}
}
