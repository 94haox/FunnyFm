//
//  PerhapsRefresh.swift
//  PerhapsRefresh
//
//  Created by 吴涛 on 2020/10/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), podcastList: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), podcastList: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, podcastList: nil)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetUrl: String = "funnyfm://open/prediction"
    let podcastList: [iTunsPod]?
}

struct PerhapsRefreshEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                VStack (alignment: .leading){
                    HStack {
                        
                    }
                }
            }
        }
//        .widgetURL(URL(string: entry.widgetUrl))
        .padding(.all, 12)
    }
}

@main
struct PerhapsRefresh: Widget {
    let kind: String = "PerhapsRefresh"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PerhapsRefreshEntryView(entry: entry)
        }
        .configurationDisplayName("即将更新")
		.supportedFamilies([.systemMedium])
    }
}
