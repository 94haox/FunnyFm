//
//  EpisodeListView.swift
//  Clips
//
//  Created by 吴涛 on 2020/9/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import FeedKit

struct EpisodeListView: View {
    
    @ObservedObject var mng: FeedManager
    
    var body: some View {
        if let feed = mng.rssFeed, let items = feed.items{
            List {
                ForEach(items) { item in
                    EpisodeItemView(item: item)
                }
            }
        }
        HStack{
            
        }
    }
}

extension RSSFeedItem: Identifiable {
    
}

