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
            EpisodePlayControl(episode: episode,
                               shown: $shown,
                               selection: $selection)
        }
    }
}


