//
//  EpisodeGridView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/13.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct EpisodeGridView: View {
    
    let episode: Episode
    
    @State var shown: Bool = true
    
    @Binding var selection: String?
    
    @ObservedObject private var playState = PlayState.shared
    
    var body: some View {
        HStack {
            FFImageView(urlString: episode.coverUrl)
                .frame(width: 50, height: 50)
                .cornerRadius(12)
                .padding(.leading, 12)
            VStack (alignment: .leading) {
                Spacer()
                if episode.author.count > 0 {
                    HStack {
                        Text(episode.author)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                HStack {
                    Text(episode.title)
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                HStack(spacing: 12){
                    Text(Date.formatIntervalToString(NSInteger(episode.duration)))
                    Text(episode.pubDate)
                    Spacer()
                }
                .padding(.top, 4)
                .font(.caption)
                .foregroundColor(Color.gray)
                Spacer()
            }
            .padding(.horizontal, 12)
            
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
                    }
                    .frame(width: 50, height: 50)
                }
                Spacer()
            }
            Spacer()
        }
    }
}


