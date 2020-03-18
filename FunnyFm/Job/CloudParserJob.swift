//
//  CloudParserJob.swift
//  FunnyFm
//
//  Created by wt on 2020/3/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation

class CloudParserJob: BaseJob {
    
    let podcast: iTunsPod
    
    init(podcast: iTunsPod) {
        self.podcast = podcast
    }
    
    override func getJobId() -> String {
        self.podcast.feedUrl
    }
    
    override func run() throws {
        let (last_title, _) = DatabaseManager.getLastEpisodeTitle(feedUrl: self.podcast.feedUrl)
        var podcast = self.podcast
        FmHttp<Pod>().requestForSingle(PodAPI.parserRss(["rssurl":podcast.feedUrl, "last_episode_title":last_title]), { (item) in
            podcast.podId = item!.podId
            FeedManager.shared.addOrUpdate(itunesPod: podcast, episodelist: item!.items)
            FeedManager.shared.sortEpisodeToGroup(DatabaseManager.allEpisodes())
            NotificationCenter.default.post(name: Notification.podcastParserSuccess, object: nil, userInfo: ["feedUrl": podcast.feedUrl])
            print("fetch_success_\(podcast.feedUrl)")
        }, { (error) in
            NotificationCenter.default.post(name: Notification.podcastParserFailure, object: nil, userInfo: ["feedUrl": podcast.feedUrl])
            print("fetch_failure_\(podcast.feedUrl)")
        })
    }
}
