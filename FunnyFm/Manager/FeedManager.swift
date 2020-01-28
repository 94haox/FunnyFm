//
//  FeedManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/13.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import FeedKit
//import FirebasePerformance
//import YBTaskScheduler

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
					var taglist = [String]()
					list.forEach({ (pod) in
						if taglist.count < 9 {
							taglist.append(pod.podId)
						}
						DatabaseManager.addItunsPod(pod: pod)
					})
					PushManager.shared.addTag(taglist: taglist)
				}
				self.podlist = DatabaseManager.allItunsPod()
				DispatchQueue.main.async {
					self.delegate?.feedManagerDidGetEpisodelistSuccess()
				}
				self.getHomeChapters()
			}){ msg in
				self.getHomeChapters()
				if msg.isSome {
					SwiftNotice.showNoticeWithText(NoticeType.error, text: msg!, autoClear: true, autoClearTime: 2)
				}
			}
		}else{
			PushManager.shared.removeAllTages()
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
		
		NotificationCenter.default.post(name: Notification.Name.init("homechapterParserBegin"), object: nil)
		DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
			var podCount = podList.count
			
			let semphore = DispatchSemaphore.init(value: 1)
			
			podList.forEach { (podcast) in
				semphore.wait()
				var pod = podcast
				var last_title = ""
				let episodeList = DatabaseManager.allEpisodes(pod: pod)
				if let episode = episodeList.first {
					last_title = episode.title
				}
				FmHttp<Pod>().requestForSingle(PodAPI.parserRss(["rssurl":pod.feedUrl,"last_episode_title":last_title]), { (item) in
					
					semphore.signal()
					pod.podId = item!.podId
					self.addOrUpdate(itunesPod: pod, episodelist: item!.items)
					if item!.items.count > 0 {
						self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
					}
					podCount -= 1
					DispatchQueue.main.async {
						if podCount == 0 {
							self.isParsering = false
							NotificationCenter.default.post(name: Notification.homeParserSuccess, object: nil)
						}
						if item!.items.count > 1{
							self.delegate?.feedManagerDidGetEpisodelistSuccess()
						}
					}
					print("fetch_success_\(podCount)")
				}, { (error) in
					semphore.signal()
					podCount -= 1
					if podCount == 0 {
						self.isParsering = false
						DispatchQueue.main.async {
							NotificationCenter.default.post(name: Notification.homeParserSuccess, object: nil)
						}
					}
					print("fetch_failure_\(podCount)")
				})

				
			}
		}
	}
	
	
	func parserForSingle(feedUrl: String, collectionId:String,complete:((Pod?)->Void)?){
		var last_title = ""
		var pod = DatabaseManager.getPodcast(feedUrl: feedUrl)
		if pod.isSome {
			let episodeList = DatabaseManager.allEpisodes(pod: pod!)
			if let episode = episodeList.first {
				last_title = episode.title
			}
		}
		
		FmHttp<Pod>().requestForSingle(PodAPI.parserRss(["rssurl":feedUrl,"last_episode_title":last_title]), { (item) in
			pod = iTunsPod.init(pod: item!)
			pod?.collectionId = collectionId
			self.addOrUpdate(itunesPod: pod!, episodelist: item!.items)
			self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
			if(complete.isSome){
				complete!(item)
			}
			DispatchQueue.main.async {
				self.podlist = DatabaseManager.allItunsPod()
				self.delegate?.feedManagerDidGetEpisodelistSuccess()
			}
		}, { (error) in
			if(complete.isSome){
				complete!(nil)
			}
		})
	}
	
	
}

// MARK: - 增删改查
extension FeedManager {
	
	func deleteAllEpisode(collectionId: String, podId: String) {
		DatabaseManager.deleteItunesPod(podId: podId)
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
		
		FmHttp<User>().requestForSingle(UserAPI.disSubscribe(podId), { (_) in
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
	
	func addOrUpdate(itunesPod:iTunsPod, episodelist: [Episode]) {
		var pod = itunesPod
		if episodelist.count < 1 {
			return
		}
		if pod.podAuthor != episodelist.first!.author {
			pod.podAuthor = episodelist.first!.author
		}
		
		DatabaseManager.updateItunsPod(pod: pod)
		
		episodelist.forEach { (item) in
			var episode = item
			episode.collectionId = pod.collectionId;
			episode.podcastUrl = pod.feedUrl
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
		var sortEpisodeList = [[Episode]]()
		autoreleasepool{
			var episodes = episodeList.suffix(100)
			episodes.sort(){$0.pubDateSecond < $1.pubDateSecond}
			
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
		}
		
		return sortEpisodeList
	}
	
}
