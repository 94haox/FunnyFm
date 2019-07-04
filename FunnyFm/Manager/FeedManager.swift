//
//  FeedManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/13.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import FeedKit


class FeedManager: NSObject {
	static let shared = FeedManager()
	
	typealias SuccessParserClosure = ([Episode]) -> Void
	
	public func parserRss(_ itunsPod:iTunsPod,
						_ success: @escaping SuccessParserClosure) {
		
		let feedURL = URL(string: itunsPod.feedUrl)!
		let parser = FeedParser(URL: feedURL)
		parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
			if result.rssFeed.isSome {
				if result.rssFeed!.iTunes.isNone {
					success([])
					return;
				}
				var list = [Episode]()
				result.rssFeed!.items!.forEach { (feedItem) in
					guard feedItem.iTunes.isSome else{
						return
					}
					var episode = Episode.init(feedItem: feedItem)
					episode.collectionId = itunsPod.collectionId;
					episode.author = itunsPod.trackName
					episode.podCoverUrl = itunsPod.artworkUrl600
					if episode.coverUrl.length() < 1 {
						episode.coverUrl = itunsPod.artworkUrl600
					}
					DatabaseManager.addEpisode(episode: episode);
					list.append(episode)
				}
				success(list)
			}
		}
	}
	
	public func parserRssSync(_ itunsPod:iTunsPod) -> [Episode] {
		
		let feedURL = URL(string: itunsPod.feedUrl)!
		let parser = FeedParser(URL: feedURL)
		let result = parser.parse()
		if result.rssFeed.isSome {
			if result.rssFeed!.iTunes.isNone {
				return []
			}
			var list = [Episode]()
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
