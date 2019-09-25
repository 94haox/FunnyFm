//
//  PlayListManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/25.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation

class PlayListManager: NSObject {
	
	static let shared = PlayListManager()
	
	var playQueue: [Episode] = {
		let playlist = DatabaseManager.allPlayItem()
		var list = [Episode]()
		playlist.forEach { (item) in
			let episode = DatabaseManager.getEpisode(trackUrl: item.trackUrl)
			if episode.isSome {
				list.append(episode!)
			}
		}
		return list
	}()
	
	/// 加入播放列表
	func queueIn(episode: Episode) {
		if isAlreadyIn(episode: episode) {
			DispatchQueue.main.async {
				SwiftNotice.noticeOnStatusBar("已在播放列表中", autoClear: false, autoClearTime: 1)
			}
			return;
		}
		
		playQueue.append(episode)
		let playItem = PlayItem.init(episode: episode, index: playQueue.count)
		DatabaseManager.add(item: playItem)
	}
	
	/// 从播放列表中去除
	func queueOut(episode: Episode) {
		for (index, item) in playQueue.enumerated() {
			if item.title.trim() == episode.title {
				playQueue.remove(at: index)
				return
			}
		}
		DatabaseManager.deletePlayItem(trackUrl: episode.trackUrl)
	}
	
	/// 将单集播放顺序提升到第二位
	func promote(episode: Episode) {
		if !isAlreadyIn(episode: episode) {
			return
		}
		
		queueOut(episode: episode)
		playQueue.insert(episode, at: 1)
		for (index, item) in playQueue.enumerated() {
			let playItem = PlayItem.init(episode: item, index: index)
			DatabaseManager.add(item: playItem)
		}
	}
	
	
	/// 是否已经在播放列表中
	func isAlreadyIn(episode: Episode) -> Bool{
		
		for item in playQueue {
			if item.title.trim() == episode.title {
				return true
			}
		}
		return false
	}
	
}
