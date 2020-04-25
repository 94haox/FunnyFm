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
    @objc optional func feedManagerDidDisSubscribeSuccess()
}

class FeedManager: NSObject {
	
	static let shared = FeedManager()
	
	weak var delegate: FeedManagerDelegate?
    
	lazy var podlist : [iTunsPod] = {
		return DatabaseManager.allItunsPod()
	}()
	
	var episodeList = [[Any]]()
    
    var waitingPodlist: [iTunsPod] = [iTunsPod]()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(forName: Notification.podcastParserSuccess, object: nil, queue: nil) { (noti) in
            self.removeDonePodcast(noti: noti)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.podcastParserFailure, object: nil, queue: nil) { (noti) in
            self.removeDonePodcast(noti: noti)
        }
    }
	
}

extension FeedManager {
	
	func getAllPods() {
        self.getHomeChapters()
		if UserCenter.shared.isLogin {
			FmHttp<iTunsPod>().requestForArray(PodAPI.getPodList, { (cloudPodlist) in
                PushManager.shared.addTags(podcasts: cloudPodlist)
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
        
        guard DatabaseManager.allItunsPod().count > 0 else {
            return
        }
		
		NotificationCenter.default.post(name: Notification.Name.init("homechapterParserBegin"), object: nil)
        
		DatabaseManager.allItunsPod().forEach { (podcast) in
            let job = CloudParserJob(podcast: podcast)
            if ConcurrentJobQueue.shared.addJob(job: job) {
                self.waitingPodlist.append(podcast)
            }
        }
	}
	
    func removeDonePodcast(noti: Notification) {
        let info = noti.userInfo!
        
        objc_sync_enter(self)
        self.waitingPodlist.removeAll { return $0.feedUrl == info["feedUrl"] as! String }
        objc_sync_exit(self)
        
        
        self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
        DispatchQueue.main.async {
            self.delegate?.feedManagerDidGetEpisodelistSuccess()
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
	
    func parserByFeedKit(podcast: iTunsPod, complete:@escaping ((Bool)->Void)) {
        guard let url = URL.init(string: podcast.feedUrl) else {
            complete(false)
            return
        }
        var pod = podcast
        FeedParser.init(URL: url).parseAsync { (result) in
            if let rss = result.rssFeed, let items = rss.items {
                let episodes = items.map { (item) -> Episode in
                    return Episode.init(feedItem: item)
                }
                if let des = rss.description {
                    pod.podDes = des
                }
                self.addOrUpdate(itunesPod: pod, episodelist: episodes)
            }
            complete(result.error != nil)
        }
    }
	
}

// MARK: - 增删改查
extension FeedManager {
	
	func deleteAllEpisode(podcastUrl: String, podId: String) {
		DatabaseManager.deleteItunesPod(feedUrl: podcastUrl)
		DatabaseManager.deleteEpisode(podcastUrl: podcastUrl)
		PushManager.shared.removeTags(tags: [podId])
        self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
        self.podlist = DatabaseManager.allItunsPod()
		if podId.length() < 1 || !UserCenter.shared.isLogin{
            self.delegate?.feedManagerDidDisSubscribeSuccess?()
			return;
		}
		
		FmHttp<User>().requestForSingle(UserAPI.disSubscribe(podId), { (_) in
			DispatchQueue.main.async {
				self.delegate?.feedManagerDidDisSubscribeSuccess?()
			}
		}) { (msg) in
            
		}
	}
}

// MARK: - 数据解析
extension FeedManager {
	
	func addOrUpdate(itunesPod:iTunsPod, episodelist: [Episode]) {
        var pod = itunesPod
        guard episodelist.count > 0 else {
            return
        }

		if pod.podAuthor != episodelist.first!.author {
			pod.podAuthor = episodelist.first!.author
		}
    
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
            if !episode.title.contains("getpodcast.xyz") {
                DatabaseManager.addEpisode(episode: episode);
            }
		}
        DatabaseManager.updateItunsPod(pod: pod)
	}
	
}


// MARK: - 排序
extension FeedManager {
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) {
		var sortEpisodeList = [[Episode]]()
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
        let serialQueue = DispatchQueue(label: "com.sort.mySerialQueue")
        serialQueue.sync {
            self.episodeList = sortEpisodeList
        }
	}
	
}
