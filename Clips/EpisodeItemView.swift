//
//  EpisodeItemView.swift
//  Clips
//
//  Created by 吴涛 on 2020/9/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import FeedKit

struct EpisodeItemView: View {
    var item: RSSFeedItem
    var body: some View {
        VStack {
            Text(item.title!)
            Text(item.author!)
        }
    }
}

