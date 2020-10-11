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
	
	/// 是否在播放状态
	var isPlay: Bool {
		get {
			UserDefaults.group!.bool(forKey: "isPlay")
		}
		
		set {
			UserDefaults.group!.setValue(newValue, forKey: "isPlay")
		}
	}
	
	/// 当前资源文件
	var title: String? {
		get {
			UserDefaults.group!.string(forKey: "currentPlay_title")
		}
		
		set {
			UserDefaults.group!.setValue(newValue, forKey: "currentPlay_title")
		}
	}
	
	var coverUrl: String? {
		get {
			UserDefaults.group!.string(forKey: "currentPlay_coverUrl")
		}
		
		set {
			UserDefaults.group!.setValue(newValue, forKey: "currentPlay_coverUrl")
		}
	}
	
}
