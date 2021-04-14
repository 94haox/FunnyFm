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
    
    let showPodcast: Bool = true
    
    @State var shown: Bool = true
    
    @Binding var selection: String?
    
    @ObservedObject private var playState = PlayState.shared
    
    var body: some View {
        HStack {
            FFImageView(urlString: episode.coverUrl)
                .frame(width: 50, height: 50, alignment: .center)
                .cornerRadius(12)
                .padding(.leading, 12)
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
            }.padding(.horizontal, 12)
            HStack {
                Spacer()
                if playState.currentItem == episode,
                   playState.playerStatus == .playing {
                    ZStack {
                        if playState.currentTime > 0 {
                            ProgressView(value: Float(playState.currentTime), total: Float(playState.totalTime))
                                .progressViewStyle(CircularProgressViewStyle())
                                .font(.largeTitle)
                        }
                        PlainButton(label: {
                            Image(systemName: "pause.circle")
                                .font(.title)
                        }) {
                            playState.play()
                        }
                        .frame(width: 45, height: 45)
                    }
                } else if playState.currentItem == episode,
                          playState.playerStatus == .loading {
                    Indicator(shown: $shown)
                        .frame(width: 45, height: 45)
                } else {
                    PlainButton(label: {
                        Image(systemName: "play.circle")
                            .font(.largeTitle)
                    }) {
                        selection = episode.id
                        PlayState.shared.config(episode)
                    }
                    .frame(width: 50, height: 50)
                }
                Spacer()
            }
        }
    }
}
