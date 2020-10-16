//
//  NowMediumView.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct NowMediumView: View {
	var entry: Provider.Entry
	
	var body: some View {
		HStack{
			VStack(alignment: .leading) {
				HStack {
					let time = timeText(time: entry.date)
					Text(time)
						.bold()
						.font(time.count > 3 ? .subheadline: .title)
						.padding(.bottom, 12)
					Spacer()
				}
				VStack (alignment: .leading){
					HStack {
						if entry.image == nil || entry.title == nil {
							Image("logo-white")
								.resizable()
								.frame(width: 55, height: 55)
								.cornerRadius(15)
						}else{
							Image(uiImage: entry.image!)
								.resizable()
								.frame(width: 60, height: 60)
								.cornerRadius(15)
						}
						VStack(alignment: .leading) {
							if entry.title == nil {
								Text("xxxxxssssss")
									.redacted(reason: .placeholder)
									.padding(.vertical, 2)
							}else{
								HStack {
									Text(entry.isPlay ? "正在播放":"等待播放")
										.font(.caption)
										.bold()
										.foregroundColor(.gray)
										.padding(.vertical, 4)
									PlayStateDotView(entry: entry)
								}
							}
							if entry.title == nil {
								Text("xxxxxxxxxxxxsssssssss")
									.redacted(reason: .placeholder)
							}else{
								Text(entry.title!)
									.font(.footnote)
									.bold()
									.lineLimit(2)
							}
						}
					}
				}
			}
		}
		.widgetURL(URL(string: entry.widgetUrl))
		.padding(.all, 12)
	}
	
	func timeText(time: Date) -> String {
		if time.hour <= 6{
			return "好的睡眠才能有好的精力哦(∪｡∪)｡｡｡zzz"
		}else if time.hour < 11 && time.hour > 6{
			return "早上好(▰˘◡˘▰)"
		}else if time.hour >= 11 && time.hour < 18{
			return "下午好"
		}else if time.hour < 19 && time.hour >= 18 {
			return "快打开看看🥳"
		}else if time.hour <= 19 && time.hour < 20 {
			return "不会吧！不会有人在回家途中不听播客吧？😏"
		}else{
			return "留一些明天再听吧"
		}
	}
}

