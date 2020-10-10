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
		SimpleEntry(date: Date(),
					title: observer.title,
					image: UIImage(),
					isPlay: observer.isPlay,
					size: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
								title: observer.title,
								image: UIImage(),
								isPlay: observer.isPlay,
								size: context.family)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
		for hourOffset in 0 ..< 12 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset*2, to: currentDate)!
			var image: UIImage? = UIImage(named: "logo-white")
			if let coverUrl = observer.coverUrl {
				if let imageData = try? Data(contentsOf: URL(string: coverUrl)!) {
					image = UIImage(data: imageData)
				}
			}
			let entry = SimpleEntry(date: entryDate,
									title: observer.title,
									image: image,
									isPlay: observer.isPlay,
									size: context.family)
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
	var size: WidgetFamily
}

struct NowEntryView : View {
	
    var entry: Provider.Entry

    var body: some View {
		if entry.size == WidgetFamily.systemSmall {
			NowSmallView(entry: entry)
		}else{
			NowMediumView(entry: entry)
		}
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
		.supportedFamilies([.systemSmall, .systemMedium])
    }
}

