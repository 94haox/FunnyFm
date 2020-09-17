//
//  FeedManager.swift
//  Clips
//
//  Created by 吴涛 on 2020/9/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import FeedKit

class FeedManager: ObservableObject {
    
    static let shared = FeedManager()
    
    @Published var rssFeed: RSSFeed?
    
    func parser(rss: String) {
        FeedParser(URL: URL.init(string: rss)!).parseAsync { [self] (result) in
            switch result {
                case .success(let feed):
                    if let rss = feed.rssFeed {
                        rssFeed = rss
                        return
                    }
                case .failure(_):
                    
                    break
            }
        }
    }
    
    
}
