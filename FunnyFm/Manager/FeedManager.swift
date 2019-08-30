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

class FeedManager: NSObject {
	
	static let shared = FeedManager()
	
}


// MARK: - 增删改查
extension FeedManager {
	
	func deleteAllEpisode(collectionId: String, podId: String) {
		DatabaseManager.deleteItunsPod(collectionId: collectionId)
		DatabaseManager.deleteEpisode(collectionId: collectionId)
		PushManager.shared.removeTags(tags: [podId])
		
		if podId.length() < 1 || !UserCenter.shared.isLogin{
			return;
		}
		FmHttp<User>().requestForSingle(UserAPI.disSubscribe(podId), success: { (_) in
		}) { (msg) in
		}
	}
}

// MARK: - 数据解析
extension FeedManager {
	
	func parserRss(_ itunsPod:iTunsPod,
				   _ success: @escaping SuccessParserClosure) {
		
		let feedURL = URL(string: itunsPod.feedUrl)!
		let parser = FeedParser(URL: feedURL)
		parser.parseAsync(queue: DispatchQueue.global(qos: .background)) { (result) in
			let list = self.parserData(result: result, itunsPod: itunsPod)
			success(list)
		}
	}
	
	func
		parserRssSync(_ itunsPod:iTunsPod) -> [Episode] {
		let feedURL = URL(string: itunsPod.feedUrl)!
		let parser = FeedParser(URL: feedURL)
		let result = parser.parse()
		return self.parserData(result: result, itunsPod: itunsPod)
	}
	
	
	func parserData(result:Result, itunsPod: iTunsPod) -> [Episode] {
		if result.rssFeed.isSome {
			if result.rssFeed!.iTunes.isNone {
				return []
			}
			var list = [Episode]()
			var pod = itunsPod
			
			if result.rssFeed!.iTunes!.iTunesAuthor.isSome && pod.podAuthor.length() < 1{
				pod.podAuthor = result.rssFeed!.iTunes!.iTunesAuthor!
				DatabaseManager.updateItunsPod(pod: pod)
			}
			
			if result.rssFeed!.copyright.isSome && pod.copyRight.length() < 1{
				pod.copyRight = result.rssFeed!.copyright!
				DatabaseManager.updateItunsPod(pod: pod)
			}
			
			
			result.rssFeed!.items!.forEach { (feedItem) in
				guard feedItem.iTunes.isSome else{
					return
				}
				var episode = Episode.init(feedItem: feedItem)
				episode.collectionId = itunsPod.collectionId;
				episode.podCoverUrl = itunsPod.artworkUrl600
				if episode.coverUrl.length() < 1 {
					episode.coverUrl = itunsPod.artworkUrl600
				}
				if episode.author.length() < 1 {
					episode.author = itunsPod.trackName
				}
				DatabaseManager.addEpisode(episode: episode);
				list.append(episode)
			}
			return list
		}
		return []
		
	}
	
}
