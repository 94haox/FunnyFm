//
//  EpisodeItemView.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/8/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct EpisodeItemView: View {
	
	var episode: Episode
    
    @State var isHover: Bool = false
    
    @State var isShow: Bool = false
    
    @ObservedObject var playManager: FMPlayerManager
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    KFImage(URL(string: episode.coverUrl))
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
                VStack(alignment:HorizontalAlignment.leading, spacing: 8){
                    Text(episode.title)
                        .font(.headline)
                        .foregroundColor(Color.black.opacity(0.8))
                        .lineLimit(2)
                    HStack (spacing: 8){
                        Text(episode.author)
                        Text(Date.formatIntervalToString(NSInteger(episode.duration)))
                        Spacer()
                        NavigationLink(destination: EpisodeInfoView(info: episode.intro)){
                            Image(systemName: "doc.plaintext")
                                .frame(width: 25, height: 25)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(Color.gray.opacity(0.8))
                }
            }
            if playManager.currentModel == episode {
                PlayerToolBarView(playManager: playManager)
            }
        }
		.background(Color.white)
		.padding(.vertical, 6)
        .cornerRadius(12)
        .shadow(color: playManager.currentModel == episode ? Color.gray.opacity(0.1): .clear, radius: 12.0, x: 0, y: 0)
    }
}

