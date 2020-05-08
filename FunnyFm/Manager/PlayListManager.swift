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
	
	var playQueue: [Episode] = [Episode]()
	
	func updatePlayQueue(){
		let playlist = DatabaseManager.allPlayItem()
		var list = [Episode]()
		playlist.forEach { (item) in
			let episode = DatabaseManager.getEpisode(trackUrl: item.trackUrl)
			if episode.isSome {
				list.append(episode!)
			}
		}
		self.playQueue = list
	}
	
	/// 加入播放列表
	func queueIn(episode: Episode) {
		if isAlreadyIn(episode: episode) {
			DispatchQueue.main.async {
				SwiftNotice.noticeOnStatusBar("已在播放列表中".localized, autoClear: true, autoClearTime: 1)
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
			}
		}
		DatabaseManager.deletePlayItem(trackUrl: episode.trackUrl)
	}
	
	/// 将单集播放顺序提升到 index 位
	func promote(episode: Episode, index: Int) {
		if !isAlreadyIn(episode: episode) {
			queueIn(episode: episode)
		}
		queueOut(episode: episode)
		for (index, item) in playQueue.enumerated() {
			let playItem = PlayItem.init(episode: item, index: index)
			DatabaseManager.add(item: playItem)
		}
	}
	
	func queueInsert(episode: Episode){
		self.promote(episode: episode, index: 0)
	}
	
	func queueInsertAffter(episode: Episode){
        if self.playQueue.count < 2 {
            self.queueIn(episode: episode)
            return
        }
		self.promote(episode: episode, index: 1)
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
