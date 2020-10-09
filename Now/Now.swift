//
//  Now.swift
//  Now
//
//  Created by 吴涛 on 2020/10/9.
//  Copyright © 2020 Duke. All rights reserved.
//

import WidgetKit
import SwiftUI
import Nuke

struct Provider: TimelineProvider {
	
	let observer = PlayStateObserver.shared
	
    func placeholder(in context: Context) -> SimpleEntry {
		
		SimpleEntry(date: Date(), title: observer.title, image: UIImage(), isPlay: observer.isPlay)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), title: observer.title, image: UIImage(), isPlay: observer.isPlay)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
		var image: UIImage? = UIImage(named: "logo-white")
		if let coverUrl = observer.coverUrl {
			if let imageData = try? Data(contentsOf: URL(string: coverUrl)!) {
				image = UIImage(data: imageData)
			}
			let entry = SimpleEntry(date: currentDate,
									title: observer.title,
									image: image,
									isPlay: observer.isPlay)
			entries.append(entry)
		}else{
			let entry = SimpleEntry(date: currentDate,
									title: observer.title,
									image: image,
									isPlay: observer.isPlay)
			entries.append(entry)
		}

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
	let widgetUrl: String = "funnyfm://open/now"
	let title: String?
	var image: UIImage?
	var isPlay: Bool
}

struct NowEntryView : View {
	
    var entry: Provider.Entry

    var body: some View {
		HStack{
			VStack(alignment: .leading) {
				VStack (alignment: .leading){
					HStack {
						if entry.image == nil {
							Image("logo-white")
								.resizable()
								.frame(width: 45, height: 45)
						}else{
							Image(uiImage: entry.image!)
								.resizable()
								.frame(width: 45, height: 45)
								.cornerRadius(15)
						}
						Spacer()
						ZStack {
							HStack {
								Spacer()
								Text("")
								Spacer()
							}
							.frame(width: 15, height: 15)
							.background(entry.isPlay ? Color.green.opacity(0.05) : Color.gray.opacity(0.05))
							.clipShape(Circle())
							HStack {
								Spacer()
								Text("")
									.font(Font.system(size: 8))
								Spacer()
							}
							.frame(width: 5, height: 5)
							.background(entry.isPlay ? Color.green.opacity(0.5) : Color.gray.opacity(0.5))
							.clipShape(Circle())
						}
					}
					Text(entry.isPlay ? "正在播放":"等待播放")
						.font(.caption)
						.bold()
						.foregroundColor(.gray)
						.padding(.vertical, 4)
					Text(entry.title == nil ? "" : entry.title!)
						.font(.footnote)
						.bold()
						.lineLimit(2)
				}
			}
		}
		.widgetURL(URL(string: entry.widgetUrl))
		.onAppear(){
			self.startObsever()
		}
		.padding(.all, 12)
    }
	
	func startObsever() {
		
	}
}

@main
struct Now: Widget {
    let kind: String = "Now"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NowEntryView(entry: entry)
        }
        .configurationDisplayName("正在播放")
        .description("正在播放的 Episode 组件")
    }
}

