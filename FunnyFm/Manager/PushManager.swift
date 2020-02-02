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
	
	func handlerNotification(userInfo: [AnyHashable : Any]){
		let type = userInfo["type"] as? String
		guard type.isNone else {
			return
		}
		
		if type! == "podcast" {
			NotificationCenter.default.post(name: Notification.podcastUpdateNewEpisode, object: nil, userInfo: userInfo)
		}
		
		if type! == "appUpdate" {
			NotificationCenter.default.post(name: Notification.appHasNewVersionReleased, object: nil, userInfo: nil)
		}
		
		if type! == "h5" {
			NotificationCenter.default.post(name: Notification.appWillOpenH5, object: nil, userInfo: userInfo)
		}
		
	}
}

