//
//  FeedManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/13.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import FeedKit

typealias SuccessParserClosure = ([Episode]) -> Void

@objc protocol FeedManagerDelegate {
	func feedManagerDidGetEpisodelistSuccess(count: Int)
	func feedManagerDidParserPodcasrSuccess()
    @objc optional func feedManagerDidDisSubscribeSuccess()
}

class FeedManager: NSObject {
	
	static let shared = FeedManager()
	
	weak var delegate: FeedManagerDelegate?
    
	var podlist : [iTunsPod] {
		DatabaseManager.allItunsPod()
	}
	
	var episodeList: [[Episode]] {
		self.sortEpisodeToGroup(DatabaseManager.allEpisodes(limit: 50))
	}
    
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
    
    func launchParser() -> Bool{
        if FunnyFm.needParser() {
            self.getAllPods()
            UserDefaults.standard.set(Date(), forKey: "lastParserTime")
			return true
        }else{
            self.delegate?.feedManagerDidParserPodcasrSuccess()
			return false
        }
    }
	
	func getAllPods() {
        self.getHomeChapters()
		if UserCenter.shared.isLogin {
			FmHttp<iTunsPod>().requestForArray(PodAPI.getPodList, { (cloudPodlist) in
                PushManager.shared.addTags(podcasts: cloudPodlist)
				DispatchQueue.main.async {
                    self.delegate?.feedManagerDidGetEpisodelistSuccess(count: 1)
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
                self.delegate?.feedManagerDidGetEpisodelistSuccess(count: 1)
			}
		}
	}
	
	func getHomeChapters() {
		
		DispatchQueue.global().async {
			if self.episodeList.count > 0 {
				DispatchQueue.main.async {
                    self.delegate?.feedManagerDidGetEpisodelistSuccess(count: 1)
				}
			}
		}
        
        guard DatabaseManager.allItunsPod().count > 0 else {
            return
        }
		
		NotificationCenter.default.post(name: Notification.Name.init("homechapterParserBegin"), object: nil)
		let normalList = DatabaseManager.allItunsPod().filter { (podcast) -> Bool in
			UserDefaults.standard.bool(forKey: "ParserFailure-\(podcast.feedUrl)")
		}
		
		let abnormalList = DatabaseManager.allItunsPod().filter { (podcast) -> Bool in
			!UserDefaults.standard.bool(forKey: "ParserFailure-\(podcast.feedUrl)")
		}
		normalList.forEach { (podcast) in
            let job = FeedParserJob(podcast: podcast)
            if ConcurrentJobQueue.shared.addJob(job: job) {
                self.waitingPodlist.append(podcast)
            }
        }
		
		abnormalList.forEach { (podcast) in
			let job = FeedParserJob(podcast: podcast)
            if ConcurrentJobQueue.shared.addJob(job: job) {
                self.waitingPodlist.append(podcast)
            }
		}
	}
	
    func removeDonePodcast(noti: Notification) {
		guard let info =  noti.userInfo else {
			return
		}
        
        objc_sync_enter(self)
        self.waitingPodlist.removeAll { return $0.feedUrl == info["feedUrl"] as! String }
        objc_sync_exit(self)
        
        DispatchQueue.main.async {
			if let itemCount = info["itemCount"] {
				self.delegate?.feedManagerDidGetEpisodelistSuccess(count: itemCount as! Int)
			}
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
			if(complete.isSome){
				complete!(item)
			}
			DispatchQueue.main.async {
				NotificationCenter.default.post(name: Notification.singleParserSuccess, object: nil)
                self.delegate?.feedManagerDidGetEpisodelistSuccess(count: item!.items.count)
			}
		}, { (error) in
			if(complete.isSome){
				complete!(nil)
			}
		})
	}
	
	func parserByFeedKit(podcast: iTunsPod, complete:((Bool)->Void)?) {
        guard let url = URL.init(string: podcast.feedUrl) else {
            complete?(false)
            return
        }
        var pod = podcast
        FeedParser.init(URL: url).parseAsync { (result) in
            switch result {
                case .success(let feed):
                    if let rss = feed.rssFeed, let items = rss.items {
                        let episodes = items.map { (item) -> Episode in
                            return Episode.init(feedItem: item)
                        }
                        if let des = rss.description {
                            pod.podDes = des
                        }
                        self.addOrUpdate(itunesPod: pod, episodelist: episodes)
                        NotificationCenter.default.post(name: Notification.singleParserSuccess, object: nil)
                    }
                    complete?(true)
                case .failure(_):
                    complete?(false)
                    break
            }
        }
    }
	
	func parserPrevByFeedKit(podcast: iTunsPod, complete:((Bool,(RSSFeed, [Episode])?)->Void)?) {
        guard let url = URL.init(string: podcast.feedUrl) else {
            complete?(false, nil)
            return
        }
        FeedParser(URL: url).parseAsync { (result) in
            switch result {
                case .success(let feed):
                    if let rss = feed.rssFeed, let items = rss.items {
                        let episodes = items.map { (item) -> Episode in
                            return Episode.init(feedItem: item)
                        }
                        complete?(true, (rss, episodes))
                        return
                    }
                case .failure(_):
                    complete?(false, nil)
                    break
            }
        }
    }
	
}

// MARK: - 增删改查
extension FeedManager {
	
	func deleteAllEpisode(podcastUrl: String, podId: String) {
		DatabaseManager.deleteItunesPod(feedUrl: podcastUrl)
		DatabaseManager.deleteEpisode(podcastUrl: podcastUrl)
		PushManager.shared.removeTags(tags: [podId])
		if podId.length() < 1 || !UserCenter.shared.isLogin{
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
				NotificationCenter.default.post(name: Notification.didUnSubscribe, object: nil)
			}
			self.delegate?.feedManagerDidDisSubscribeSuccess?()
			return;
		}
		
		FmHttp<User>().requestForSingle(UserAPI.disSubscribe(podId), { (_) in
			DispatchQueue.main.async {
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
					NotificationCenter.default.post(name: Notification.didUnSubscribe, object: nil)
				}
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
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) -> [[Episode]] {
		var sortEpisodeList = [[Episode]]()
        var episodes = episodeList
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
		return sortEpisodeList;
	}
	
}
