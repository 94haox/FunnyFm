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
					return;
				}
				var list = [Episode]()
				result.rssFeed!.items!.forEach { (feedItem) in
					var episode = Episode.init(feedItem: feedItem)
					episode.collectionId = itunsPod.collectionId;
					episode.author = itunsPod.trackName
					episode.podCoverUrl = itunsPod.artworkUrl600
					DatabaseManager.addEpisode(episode: episode);
					list.append(episode)
				}
				success(list)
			}
		}
	}
	
}
