//
//  Database.Episode.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import WCDBSwift

// MARK: Episode 操作
extension DatabaseManager {
	
	/// 所有 episode 缓存
	static public func allEpisodes(limit: Int) -> [Episode] {
		let episodeList : [Episode] = try! database.getObjects(fromTable: exsitEpisodeTable, orderBy: [Episode.Properties.pubDateSecond], limit: limit, offset: 0).sorted(by: { (obj1, obj2) -> Bool in
			let second1 = obj1.pubDateSecond
			let second2 = obj2.pubDateSecond
			return second1 >= second2
		})
		
		var listDic = [String:Episode]()
		var list = [Episode]()
		let podlist = self.allItunsPod()
		var collectionidList = [String]()
		
		podlist.forEach { (pod) in
			collectionidList.append(pod.collectionId)
		}
		#if os(iOS)
		episodeList.forEach { (episode) in
			if listDic[episode.title] == nil  && collectionidList.contains(episode.collectionId) {
				listDic[episode.title] = episode
				list.append(episode)
			}else{
				self.deleteEpisode(trackUrl: episode.trackUrl)
			}
		}
		return list
		#endif
		return episodeList
	}
	
	/// 指定 Pod 下的所有 Episode
	static public func allEpisodes(pod: iTunsPod) -> [Episode] {
		let objects: [Episode] = try! database.getObjects(fromTable: exsitEpisodeTable,
														where: Episode.Properties.podcastUrl == pod.feedUrl)
		let episodeList = objects.sorted(by: { (obj1, obj2) -> Bool in
			let second1 = obj1.pubDateSecond
			let second2 = obj2.pubDateSecond
			return second1 <= second2
		})
		
		var listDic = [String:Episode]()
		var list = [Episode]()
		episodeList.forEach { (episode) in
			if listDic[episode.title] == nil {
				listDic[episode.title] = episode
				list.append(episode)
			}
		}
		return list
	}
	
	
	/// 通过 trackUrl 获取指定单集
	
	static public func getEpisode(trackUrl: String) -> Episode?{
		let episodeList: [Episode] = try! database.getObjects(fromTable: exsitEpisodeTable,
		where: Episode.Properties.trackUrl == trackUrl)
		return episodeList.first
	}
	
	static public func getEpisode(id: String) -> Episode? {
		let episodeList: [Episode] = try! database.getObjects(fromTable: exsitEpisodeTable,
		where: Episode.Properties.id == id)
		return episodeList.first
	}
	
	/// 添加 Episode
	
	static public func addEpisode(episode: Episode){
		
		let exsitEpisode: [Episode] = try! database.getObjects(fromTable: exsitEpisodeTable,
															   where: (Episode.Properties.trackUrl == episode.trackUrl && Episode.Properties.podcastUrl == episode.podcastUrl))
		if exsitEpisode.count > 0 {
			let oldEpisode = exsitEpisode.first!
			if oldEpisode.podcastUrl.count < 1 {
				try! self.database.update(table: exsitEpisodeTable, on: Episode.Properties.all, with: episode, where: (Episode.Properties.trackUrl == episode.trackUrl && Episode.Properties.podcastUrl == episode.podcastUrl))
			}
			return
		}
		try! self.database.insert(objects: episode, intoTable: exsitEpisodeTable)
	}
	
	
	/// 通过 collectionId 删除所有Episode
	static public func deleteEpisode(collectionId: String) {
		do{
			try database.delete(fromTable: exsitEpisodeTable,where: Episode.Properties.collectionId == collectionId)
		}
		catch{
			print(error)
		}
			
	}
	
	static public func deleteEpisode(podcastUrl: String) {
		do{
			try database.delete(fromTable: exsitEpisodeTable,where: Episode.Properties.podcastUrl == podcastUrl)
		}
		catch{
			print(error)
		}
			
	}
	
	/// 通过音频文件 url 删除单集
	static public func deleteEpisode(trackUrl: String) {
		do{
			try database.delete(fromTable: exsitEpisodeTable,where: Episode.Properties.trackUrl == trackUrl)
		}
		catch{
			print(error)
		}
	}

	
}
