//
//  ImportManager.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/15.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class ImportManager: NSObject {
	
	static func handler(url: URL) -> Bool {
		
		if url.absoluteString.hasPrefix("funnyfm://import") {
			self.showOpmlList(url: url)
			return true
		}
		
		if url.absoluteString.hasPrefix("funnyfm://rss") {
			self.showRss(url: url)
			return true
		}
		
		if url.absoluteString.hasPrefix("funnyfm://podcast") {
			self.showDetail(url: url)
			return true
		}
		
		return false
	}
	
	
	static func showOpmlList(url: URL) {
		
		guard let path = url.absoluteString.components(separatedBy: "?").last else {
			return
		}
		self.parserOPML(url: path) { (items) in
			let opmlVC = OpmlListViewController()
			opmlVC.items = items
			guard let navi = AppDelegate.current.window.rootViewController as? UINavigationController else {
				return
			}
			navi.pushViewController(opmlVC)
		}
	}
	
	static func showRss(url: URL) {
		guard let rssUrl = url.absoluteString.components(separatedBy: "?").last else {
			return
		}
		if rssUrl.contains("https://podcasts.apple.com") {
			return
		}
		
		if rssUrl.contains("opml") {
			self.showOpmlList(url: url)
			return
		}
		
		self.getPrev(url: rssUrl)
	}
	
	static func searchPodcast() {
		
	}
	
	static func getPrev(url: String) {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
			ClientConfig.shared.tabbarVC.changeViewController(to: 1)
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
				NotificationCenter.default.post(name: Notification.Name.init(rawValue: "ImportGetPrev"), object: nil, userInfo: ["rssUrl": url])
			}
		}
	}
	
	
	static func showDetail(url: URL) {
		let urlString = url.absoluteString
		let params = urlString.components(separatedBy: "=")
		if params.count > 0{
			let podId = params.last!
			let pod = DatabaseManager.getPodcast(podId: podId)
			if pod.isNone {
				return
			}
			let vc = PodDetailViewController.init(pod: pod!)
			guard let navi = AppDelegate.current.window.rootViewController as? UINavigationController else {
				return
			}
			navi.pushViewController(vc)
		}
	}
	
}


extension ImportManager {
	
	
	static func parserOPML(url: String, complete: @escaping (([OPMLItem]) -> Void)) {
		Hud.shared.show()
		DispatchQueue.global().async {
			var opmlData = Data()
			if url.hasPrefix("file") {
				let shared = UserDefaults.init(suiteName: "group.com.duke.Pine")
				guard let data = shared?.data(forKey: url) else {
					return
				}
				shared?.set(nil, forKey: url)
				opmlData = data
			}else{
				guard let opmlUrl = URL(string: url), let data = try? Data(contentsOf: opmlUrl) else {
					return
				}
				opmlData = data
			}
			
			guard let opmlString = String.init(data: opmlData, encoding: .utf8) else {
				DispatchQueue.main.async {
					showAutoHiddenHud(style: .error, text: "OPML 内容格式错误")
					Hud.shared.hide()
				}
				return
			}
			let parser = Parser(text: opmlString)
			let _ = parser.success { (items) in
				DispatchQueue.main.async {
					Hud.shared.hide()
					complete(items)
				}
			}
			
			let _ = parser.failure { (error) in
				DispatchQueue.global().async {
					showAutoHiddenHud(style: .error, text: "OPML 内容解析失败")
				}
				print(error)
			}
			parser.main()
		}
	}
	
}
