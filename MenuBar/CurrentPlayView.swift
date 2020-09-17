//
//  CurrentPlayView.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/8/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import AVFoundation

struct CurrentPlayView: View {
	
	var episode: Episode?
	
    var body: some View {
		HStack {
			leftView
			Spacer()
			HStack {
				Image(systemName: "play.fill")
					.font(.title2)
					.foregroundColor(Color.accentColor)
					.onTapGesture {
                        guard let item = episode else {
                            return
                        }
                        FMPlayerManager.shared.config(item)
                        FMPlayerManager.shared.play()
					}
				Text(Date.formatIntervalToHMS(Int(episode?.duration ?? 0)))
					.font(.callout)
			}
			.frame(width: 40, height: 40)
			.cornerRadius(15)
		}
    }
	
	var leftView: some View {
		HStack {
			HStack {
				KFImage(URL(string: episode?.coverUrl ?? ""))
					.resizable()
					.frame(width: 70, height: 70)
			}
			.background(Color.gray.opacity(0.2))
			.cornerRadius(15)
			
			VStack(alignment:HorizontalAlignment.leading){
				Text(episode?.title ?? "")
					.font(.headline)
					.foregroundColor(Color.black.opacity(0.8))
					.lineLimit(2)
				HStack {
					Text(episode?.author ?? "")
						.foregroundColor(Color.gray.opacity(0.8))
					Text(episode?.pubDate ?? "")
						.foregroundColor(Color.gray.opacity(0.8))
				}
				.font(.subheadline)
			}
		}
	}
}


