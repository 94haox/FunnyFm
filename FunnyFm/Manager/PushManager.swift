//
//  PushManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/3.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit



class PushManager: NSObject {
	
	static let shared = PushManager.init()
	
	func configureJpushSDK(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
		let entity = JPUSHRegisterEntity.init()
		entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue | JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
		JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
		JPUSHService.setup(withOption: launchOptions, appKey: "96982e6dbcb84da30216bdb1", channel: "app store", apsForProduction: true)
		print(JPUSHService.registrationID())
	}
	
	func removeAllTages(){
		JPUSHService.cleanTags({ (code, tags, seq) in
		}, seq: 1)
	}
	
	func removeTags(tags: [String]){
		let tagset = Set.init(tags)
		JPUSHService.deleteTags(tagset, completion: { (code, tags, seq) in
		}, seq: 1)
	}
	
	func addTag(taglist: [String]) {
		JPUSHService.addTags(Set.init(taglist), completion: { (code, tags, seq) in
		}, seq: 1)
	}
	
	
	
}

extension PushManager : JPUSHRegisterDelegate {
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
		
	}
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
		
	}
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
		
	}
	
	
}
