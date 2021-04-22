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
    
    @State var isShowDetail: Bool = false
    
    @Binding var selection: String?
    
    var body: some View {
        HStack {
            FFImageView(urlString: episode.coverUrl)
                .frame(width: 50, height: 50, alignment: .center)
                .cornerRadius(12)
                .padding(.leading, 12)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 0)
                .onTapGesture {
                    isShowDetail = true
                }
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
                EpisodePlayControl(episode: episode,
                                   shown: $shown,
                                   selection: $selection)
                Spacer()
            }
        }
        .sheet(isPresented: $isShowDetail) {
            EpisodeView(show: $isShowDetail,
                        shown: $shown,
                        selection: $selection,
                        podcast: self.fetchPodcast(),
                        episode: episode)
                .frame(minWidth: 600, idealWidth: 600, maxWidth: 600, minHeight: 400, idealHeight: 450, maxHeight: 450)
        }
    }
    
    func fetchPodcast() -> GPodcast? {
        if let podcast = CDPodcast.fetchOne(with: episode.podcastUrl) {
            return podcast
        }
        return nil
    }
}

struct EpisodePlayControl: View {
    
    let episode: Episode
    
    @Binding var shown: Bool
    
    @Binding var selection: String?
    
    @ObservedObject private var playState = PlayState.shared
    
    var body: some View {
        HStack {
            if playState.currentItem == episode,
               playState.playerStatus == .playing {
                ZStack {
                    if playState.currentTime > 0 {
                        ProgressView(value: Float(playState.currentTime), total: Float(playState.totalTime))
                            .progressViewStyle(CircularProgressViewStyle())
                            .font(.largeTitle)
                    }
                    Image(systemName: "pause.circle")
                        .font(.title)
                        .onTapGesture {
                            playState.play()
                        }
                }
            } else if playState.currentItem == episode,
                      playState.playerStatus == .loading {
                Indicator(shown: $shown)
            } else {
                Image(systemName: "play.circle")
                    .font(.title)
                    .onTapGesture {
                        selection = episode.id
                        PlayState.shared.config(episode)
                    }
            }
        }
    }
}
