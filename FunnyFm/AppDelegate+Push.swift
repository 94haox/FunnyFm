//
//  AppDelegate+Push.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation


extension AppDelegate: JPUSHRegisterDelegate {
	
	@objc func setupJpush(){
        UserDefaults.standard.set(true, forKey: ff_isConfigANPS)
		let entity = JPUSHRegisterEntity.init()
		entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue | JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
		JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
		JPUSHService.setup(withOption: self.options, appKey: "96982e6dbcb84da30216bdb1", channel: "app store", apsForProduction: true)
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		JPUSHService.registerDeviceToken(deviceToken)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		JPUSHService.handleRemoteNotification(userInfo)
		completionHandler(UIBackgroundFetchResult.newData)
	}

	func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
		
	}

	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
		completionHandler(Int(UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.alert.rawValue));
	}
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
		let userinfo = response.notification.request.content.userInfo
		if let trigger = response.notification.request.trigger {
			if trigger.isKind(of: UNPushNotificationTrigger.self) {
				JPUSHService.handleRemoteNotification(userinfo)
				PushManager.shared.handlerNotification(userInfo: userinfo)
			}
		}
		completionHandler()
	}
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
		
	}
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        restorationHandler([FMToolBar.shared])
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {

        if DownloadManager.shared.sessionManager.identifier == identifier {
            DownloadManager.shared.sessionManager.completionHandler = completionHandler
        }
    }
}
