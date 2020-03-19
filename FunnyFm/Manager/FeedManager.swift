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
    
    var waitingPodlist: [iTunsPod] = [iTunsPod]()
	
}

extension FeedManager {
	
	func getAllPods() {
        self.getHomeChapters()
		if UserCenter.shared.isLogin {
			FmHttp<iTunsPod>().requestForArray(PodAPI.getPodList, { (cloudPodlist) in
				if let list = cloudPodlist {
					var taglist = [String]()
					list.forEach({ (pod) in
						if pod.podId.length() > 0 {
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
				if msg.isSome {
					SwiftNotice.showNoticeWithText(NoticeType.error, text: msg!, autoClear: true, autoClearTime: 2)
				}
			}
		}else{
			PushManager.shared.removeAllTages()
			DispatchQueue.main.async {
				self.delegate?.feedManagerDidGetEpisodelistSuccess()
			}
		}
	}
	
	func getHomeChapters() {
		
		DispatchQueue.global().async {
			self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
			if self.episodeList.count > 0 {
				DispatchQueue.main.async {
					self.delegate?.feedManagerDidGetEpisodelistSuccess()
				}
			}
		}
		
		NotificationCenter.default.post(name: Notification.Name.init("homechapterParserBegin"), object: nil)
        
        NotificationCenter.default.addObserver(forName: Notification.podcastParserSuccess, object: nil, queue: nil) { (noti) in
            self.removeDonePodcast(noti: noti)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.podcastParserFailure, object: nil, queue: nil) { (noti) in
            self.removeDonePodcast(noti: noti)
        }
        
        
		DatabaseManager.allItunsPod().forEach { (podcast) in
            let job = CloudParserJob(podcast: podcast)
            if ConcurrentJobQueue.shared.addJob(job: job) {
                self.waitingPodlist.append(podcast)
            }
        }
	}
	
    func removeDonePodcast(noti: Notification) {
        self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
        DispatchQueue.main.async {
            self.delegate?.feedManagerDidGetEpisodelistSuccess()
        }
        let info = noti.userInfo!
        var delIndex = -1
        for (index, podcast) in self.waitingPodlist.enumerated() {
            if podcast.feedUrl == info["feedUrl"] as! String {
                delIndex = index
                break
            }
        }
        if delIndex >= 0 {
            self.waitingPodlist.remove(at: delIndex)
        }
        
        if self.waitingPodlist.count <= 0 {
            NotificationCenter.default.post(name: Notification.homeParserSuccess, object: nil)
        }
    }
	
	func parserForSingle(feedUrl: String, collectionId:String,complete:((Pod?)->Void)?){
        var (last_title, pod) = DatabaseManager.getLastEpisodeTitle(feedUrl: feedUrl)
		FmHttp<Pod>().requestForSingle(PodAPI.parserRss(["rssurl":feedUrl,"last_episode_title":last_title]), { (item) in
			pod = iTunsPod.init(pod: item!)
			pod?.collectionId = collectionId
			self.addOrUpdate(itunesPod: pod!, episodelist: item!.items)
			self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
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
	
	func deleteAllEpisode(podcastUrl: String, podId: String) {
		DatabaseManager.deleteItunesPod(feedUrl: podcastUrl)
		DatabaseManager.deleteEpisode(podcastUrl: podcastUrl)
		PushManager.shared.removeTags(tags: [podId])
		DispatchQueue.main.async {
			self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
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
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) {
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
		
        self.episodeList = sortEpisodeList
	}
	
}
