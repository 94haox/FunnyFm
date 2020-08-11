//
//  CurrentPlayView.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/8/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct CurrentPlayView: View {
	
	var episode: Episode?
	
    var body: some View {
		HStack {
			HStack {
				KFImage(URL(string: episode?.coverUrl ?? ""))
					.resizable()
					.frame(width: 50, height: 50)
			}
			.background(Color.gray.opacity(0.2))
			.cornerRadius(15)
			
			VStack(alignment:HorizontalAlignment.leading){
				Text(episode?.title ?? "")
					.font(.headline)
					.foregroundColor(Color.black.opacity(0.8))
					.lineLimit(2)
				Text(episode?.author ?? "")
					.font(.subheadline)
					.foregroundColor(Color.gray.opacity(0.8))
			}
			Spacer()
			HStack {
				Image(systemName: "play.fill")
					.font(.title2)
					.foregroundColor(Color.accentColor)
					.onTapGesture {
						let player = AudioPlayer()
						let item = AudioItem(mediumQualitySoundURL: URL.init(string: "https://a.anw.red/audio/anyway-112.mp3")!)
						player.play(item: item!)
					}
			}
			.frame(width: 40, height: 40)
			.cornerRadius(15)
		}
		.background(Color.white)
		.padding(.vertical, 6)
		.padding(.horizontal, 12)
    }
}
