//
//  PlayStateObserver.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/10/9.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation

class PlayStateObserver: NSObject {
	
	static let shared = PlayStateObserver()
	
	let defaults = UserDefaults.init(suiteName: "group.com.duke.Pine")
	
	/// 是否在播放状态
	var isPlay: Bool {
		get {
			defaults!.bool(forKey: "isPlay")
		}
		
		set {
			defaults?.setValue(newValue, forKey: "isPlay")
		}
	}
	
	/// 当前资源文件
	var title: String? {
		get {
			defaults!.string(forKey: "currentPlay_title")
		}
		
		set {
			defaults?.setValue(newValue, forKey: "currentPlay_title")
		}
	}
	
	var coverUrl: String? {
		get {
			defaults!.string(forKey: "currentPlay_coverUrl")
		}
		
		set {
			defaults?.setValue(newValue, forKey: "currentPlay_coverUrl")
		}
	}
	
}
