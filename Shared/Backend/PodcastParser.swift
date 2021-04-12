//
//  PodcastParser.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import FeedKit

class PodcastParser {

    class func parserByFeedKit(podcast: GPodcast, complete:@escaping (Result<Feed, ParserError>?)->Void) {
        guard let url = URL(string: podcast.rss_url) else {
            complete(nil)
            return
        }
        FeedParser(URL: url).parseAsync { (result) in
            complete(result)
        }
    }
}
