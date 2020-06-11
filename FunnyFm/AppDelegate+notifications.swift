//
//  AppDelegate+notifications.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation

// MARK: - Notifications
extension AppDelegate {
    	
	func dw_addNotifies(){
		NotificationCenter.default.addObserver(self, selector: #selector(setupJpush), name: Notification.setupNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toLoginVC), name: Notification.needLoginNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toMainVC), name: Notification.toMainNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toDiscovery), name: Notification.toDiscoveryNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(episodeUpdate(noti:)), name: Notification.podcastUpdateNewEpisode, object: nil)
		

	}
	
	@objc func toDiscovery() {
		DispatchQueue.main.async {
			self.window.rootViewController = ClientConfig.shared.rootController()
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
				if ClientConfig.shared.isIPad {
					ClientConfig.shared.masterVC.changeViewController(to: 1)
				}else{
					ClientConfig.shared.tabbarVC.changeViewController(to: 1)
				}
			}
		}
	}
	
	@objc func toLoginVC(){
		DispatchQueue.main.async {
            self.window.rootViewController = ClientConfig.shared.rootController()
		}
		DispatchQueue.main.async {
			let loginNavi = UINavigationController.init(rootViewController: AppleLoginTypeViewController.init())
            loginNavi.navigationBar.isHidden = true
            self.window.rootViewController!.present(loginNavi, animated: true, completion: nil)
		}
	}
	
	@objc func toMainVC(){
		DispatchQueue.main.async {
            self.window.rootViewController = ClientConfig.shared.rootController()
		}
	}
	
	@objc func episodeUpdate(noti: Notification){
		if noti.userInfo.isSome {
			let feedurl = noti.userInfo!["feedurl"] as! String
			let pod = DatabaseManager.getPodcast(feedUrl: feedurl)
			if pod.isNone {
				return
			}
			let vc = PodDetailViewController.init(pod: pod!)
			let navi = self.window.rootViewController as! UINavigationController
			navi.pushViewController(vc)
		}
	}
	
}
