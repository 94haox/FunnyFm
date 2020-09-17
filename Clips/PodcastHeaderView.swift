//
//  PodcastHeaderView.swift
//  Clips
//
//  Created by 吴涛 on 2020/9/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import FeedKit

struct PodcastHeaderView: View {
    
    @ObservedObject var mng: FeedManager
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image(systemName: "play")
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    if mng.rssFeed == nil {
                        Text("podcast.trackName")
                            .redacted(reason: .placeholder)
                    }else{
                        Text(mng.rssFeed!.title!)
                    }
                }
                VStack {
                    if mng.rssFeed == nil {
                        Group{
                            Text("podcast.podDes")
                            Text("podcast.podAuthor")
                        }
                        .redacted(reason: .placeholder)
                    }else{
                        Text(mng.rssFeed!.description!)
                        Text(mng.rssFeed!.iTunes!.iTunesAuthor!)
                    }
                }
            }
        }
    }
}

