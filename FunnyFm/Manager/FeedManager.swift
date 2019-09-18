//
//  FeedManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/13.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import FeedKit
import FirebasePerformance
import YBTaskScheduler

typealias SuccessParserClosure = ([Episode]) -> Void

@objc protocol FeedManagerDelegate {
	func feedManagerDidGetEpisodelistSuccess()
	func feedManagerDidParserPodcasrSuccess()
	
}

class FeedManager: NSObject {
	
	static let shared = FeedManager()
	
	weak var delegate: FeedManagerDelegate?
	
	var isParsering = false
	
	lazy var podlist : [iTunsPod] = {
		return DatabaseManager.allItunsPod()
	}()
	
	lazy var episodeList : [[Any]] = {
		return []
	}()
	
}

extension FeedManager {
	
	func getAllPods() {
		if UserCenter.shared.isLogin {
			FmHttp<iTunsPod>().requestForArray(PodAPI.getPodList, { (cloudPodlist) in
				if let list = cloudPodlist {
					var taglist = [AnyHashable: Any]()
					list.forEach({ (pod) in
						taglist[pod.podId] = "1"
						DatabaseManager.addItunsPod(pod: pod)
					})
					
					PushManager.shared.addTag(taglist: taglist)
				}
				
				self.podlist = DatabaseManager.allItunsPod()
				self.getHomeChapters()
			}){ msg in
				self.podlist = DatabaseManager.allItunsPod()
				self.getHomeChapters()
			}
		}else{
			PushManager.shared.removeAllTages()
			self.podlist = DatabaseManager.allItunsPod()
			DispatchQueue.main.async {
				self.delegate?.feedManagerDidGetEpisodelistSuccess()
			}
			self.getHomeChapters()
		}
		
	}
	
	func getHomeChapters() {
		
		DispatchQueue.global().async {
			self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
			if self.episodeList.count > 0 {
				DispatchQueue.main.async {
					self.delegate?.feedManagerDidGetEpisodelistSuccess()
				}
			}
		}
		
		let podList = DatabaseManager.allItunsPod()
		
		if self.isParsering{
			return
		}else if podList.count > 0{
			self.isParsering = true
		}else{
			DispatchQueue.main.async {
				self.delegate?.feedManagerDidGetEpisodelistSuccess()
			}
			return;
		}
		
		NotificationCenter.default.post(name: NSNotification.Name.init("homechapterParserBegin"), object: nil)
		DispatchQueue.global().async {
			var podCount = podList.count
			
			let semphore = DispatchSemaphore.init(value: 2)
			
			podList.forEach { (pod) in
				semphore.wait()
				var last_title = ""
				let episodeList = DatabaseManager.allEpisodes(pod: pod)
				if let episode = episodeList.first {
					last_title = episode.title
				}
				FmHttp<Pod>().requestForSingle(PodAPI.parserRss(["rssurl":pod.feedUrl,"last_episode_title":last_title]), success: { (item) in
					semphore.signal()
					self.addOrUpdate(itunesPod: pod, episodelist: item!.items)
					self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
					podCount -= 1
					DispatchQueue.main.async {
						if podCount == 0 {
							self.isParsering = false
							NotificationCenter.default.post(name: NSNotification.Name.init("homechapterParserSuccess"), object: nil)
						}
						self.delegate?.feedManagerDidGetEpisodelistSuccess()
					}
				}, { (error) in
					semphore.signal()
					podCount -= 1
					if podCount == 0 {
						self.isParsering = false
						DispatchQueue.main.async {
							NotificationCenter.default.post(name: NSNotification.Name.init("homechapterParserSuccess"), object: nil)
						}
					}
				})

				
			}
		}
	}
	
	
	func parserForSingle(feedUrl: String, collectionId:String){
		var last_title = ""
		var pod = DatabaseManager.getItunsPod(collectionId: collectionId)
		if pod.isSome {
			let episodeList = DatabaseManager.allEpisodes(pod: pod!)
			if let episode = episodeList.first {
				last_title = episode.title
			}
		}
		
		FmHttp<Pod>().requestForSingle(PodAPI.parserRss(["rssurl":feedUrl,"last_episode_title":last_title]), success: { (item) in
			pod = iTunsPod.init(pod: item!)
			pod?.collectionId = collectionId
			self.addOrUpdate(itunesPod: pod!, episodelist: item!.items)
			self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
			print("fetched")
			DispatchQueue.main.async {
				self.podlist = DatabaseManager.allItunsPod()
				self.delegate?.feedManagerDidGetEpisodelistSuccess()
			}
		}, { (error) in
		})
	}
	
	
}

// MARK: - 增删改查
extension FeedManager {
	
	func deleteAllEpisode(collectionId: String, podId: String) {
		DatabaseManager.deleteItunsPod(collectionId: collectionId)
		DatabaseManager.deleteEpisode(collectionId: collectionId)
		PushManager.shared.removeTags(tags: [podId])
		DispatchQueue.main.async {
			self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
			self.podlist = DatabaseManager.allItunsPod()
			self.delegate?.feedManagerDidGetEpisodelistSuccess()
		}
		
		if podId.length() < 1 || !UserCenter.shared.isLogin{
			return;
		}
		
		FmHttp<User>().requestForSingle(UserAPI.disSubscribe(podId), success: { (_) in
			DispatchQueue.main.async {
				self.podlist = DatabaseManager.allItunsPod()
				self.delegate?.feedManagerDidGetEpisodelistSuccess()
			}
		}) { (msg) in
		}
	}
}

// MARK: - 数据解析
extension FeedManager {
	
	func addOrUpdate(itunesPod:iTunsPod, episodelist: Array<Episode>) {
		var pod = itunesPod
		if episodelist.count < 1 {
			return
		}
		if pod.podAuthor != episodelist.first!.author {
			pod.podAuthor = episodelist.first!.author
			DatabaseManager.updateItunsPod(pod: pod)
		}
		
		episodelist.forEach { (item) in
			var episode = item
			episode.collectionId = pod.collectionId;
			episode.podCoverUrl = pod.artworkUrl600
			if episode.coverUrl.length() < 1 {
				episode.coverUrl = pod.artworkUrl600
			}
			if episode.author.length() < 1 {
				episode.author = pod.trackName
			}
			DatabaseManager.addEpisode(episode: episode);
		}
	}
	
}


// MARK: - 排序
extension FeedManager {
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) -> [[Episode]]{
		
		var episodes = episodeList.suffix(100)
		episodes.sort(){$0.pubDateSecond < $1.pubDateSecond}
		var sortEpisodeList = [[Episode]]()
		
		var dic : [String: [Episode]] = [:]
		var index = 0;
		episodes.forEach { (episode) in
			var list = dic[episode.pubDate]
			if list.isSome {
				list!.append(episode)
			}else{
				list = Array.init()
				list!.append(episode)
				index += 1
			}
			dic[episode.pubDate] = list!
			if sortEpisodeList.count < index{
				sortEpisodeList.append(list!)
			}else{
				sortEpisodeList.remove(at: index-1)
				sortEpisodeList.append(list!)
			}
		}
		return sortEpisodeList
	}
	
}
