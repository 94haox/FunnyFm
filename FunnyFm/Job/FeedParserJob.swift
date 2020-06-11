//
//  FeedParserJob.swift
//  FunnyFm
//
//  Created by wt on 2020/5/31.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import FeedKit

class FeedParserJob: BaseJob {
    
    let podcast: iTunsPod
    
    init(podcast: iTunsPod) {
        self.podcast = podcast
    }
    
    override func getJobId() -> String {
        self.podcast.feedUrl
    }
    
    override func run() throws {
        guard let url = URL.init(string: self.podcast.feedUrl) else {
            self.sendFailure()
            return
        }
        let result = FeedParser.init(URL: url).parse()
        switch result {
        case .rss(let rss):
            self.formatResult(rss: rss)
        default:
            self.sendFailure()
            return;
        }
    }
    
    private func formatResult(rss: RSSFeed) {
        var pod = self.podcast
        guard let items = rss.items else {
            self.sendFailure()
            return
        }
        let episodes = items.map { (item) -> Episode in
            return Episode.init(feedItem: item)
        }
        if let des = rss.description {
            pod.podDes = des
        }
		UserDefaults.standard.set(false, forKey: "ParserFailure-\(podcast.feedUrl)")
		var count = DatabaseManager.allEpisodes(pod: pod).count
        FeedManager.shared.addOrUpdate(itunesPod: pod, episodelist: episodes)
		count = items.count - count
        NotificationCenter.default.post(name: Notification.podcastParserSuccess, object: nil, userInfo: ["feedUrl": pod.feedUrl, "itemCount": count])
    }
    
    private func sendFailure() {
		UserDefaults.standard.set(true, forKey: "ParserFailure-\(podcast.feedUrl)")
        NotificationCenter.default.post(name: Notification.podcastParserFailure, object: nil, userInfo: ["feedUrl": podcast.feedUrl])
        print("fetch_failure_\(podcast.feedUrl)")
    }

}
