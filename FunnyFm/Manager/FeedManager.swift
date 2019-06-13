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
	
	public func parserRss(url:String) {
		let feedURL = URL(string: url)!
		let parser = FeedParser(URL: feedURL)
		parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
			// Do your thing, then back to the Main thread
			if result.rssFeed.isSome {
				result.rssFeed!.items!.map { (item) -> RSSFeedItem in
					print(item.enclosure!.attributes!.url!)
					return item
				}
			}
			DispatchQueue.main.async {
				
			}
		}
	}
	
}
