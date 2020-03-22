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
        guard VipManager.shared.isVip, VipManager.shared.allowEpisodeNoti  else {
            self.removeAllTages()
            return
        }
		JPUSHService.setTags(Set.init(taglist), completion: { (code, tags, seq) in }, seq: 1)
	}
    
    func addAllDatabaseTags() {
        let list = DatabaseManager.allItunsPod()
        var taglist = [String]()
        list.forEach({ (pod) in
            if pod.podId.length() > 0 {
                taglist.append(pod.podId)
            }
        })
        PushManager.shared.addTag(taglist: taglist)
    }
    
    func addTags(podcasts: [iTunsPod]?) {
        guard let list = podcasts else {
            return
        }
        var taglist = [String]()
        list.forEach({ (pod) in
            if pod.podId.length() > 0 {
                taglist.append(pod.podId)
            }
            DatabaseManager.addItunsPod(pod: pod)
        })
        self.addTag(taglist: taglist)
    }
	
	func handlerNotification(userInfo: [AnyHashable : Any]){
		let type = userInfo["type"] as? String
		guard type.isSome else {
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

