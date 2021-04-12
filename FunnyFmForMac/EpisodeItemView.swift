//
//  EpisodeItemView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct EpisodeItemView: View {
    
    let episode: Episode
    
    private var showPodcast: Bool = true
    
    init(ep: Episode,
         showPodcast: Bool = false) {
        episode = ep
    }
    
    var body: some View {
        HStack {
            FFImageView(urlString: episode.coverUrl)
                .frame(width: 50, height: 50, alignment: .center)
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 0)
            VStack (alignment: .leading) {
                if showPodcast, episode.author.count > 0 {
                    HStack {
                        Text(episode.author)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                }
                HStack {
                    Text(episode.title)
                        .font(.headline)
                        .bold()
                        .padding(.bottom, 2)
                    Spacer()
                }
                HStack(spacing: 12){
                    Text(Date.formatIntervalToString(NSInteger(episode.duration)))
                    Text(episode.pubDate)
                    Spacer()
                }
                .font(.caption)
                .foregroundColor(Color.gray)
            }
        }
    }
}
