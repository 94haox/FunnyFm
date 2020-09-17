//
//  PodcastDetaliView.swift
//  Clips
//
//  Created by 吴涛 on 2020/9/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import FeedKit

struct PodcastDetaliView: View {
        
    var body: some View {
        VStack {
            PodcastHeaderView(mng: FeedManager.shared)
            EpisodeListView(mng: FeedManager.shared)
        }
    }
}

