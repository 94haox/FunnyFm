//
//  ClipsApp.swift
//  Clips
//
//  Created by 吴涛 on 2020/9/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import FeedKit

enum EnterType {
    case episode
    case podcast
}


@main
struct ClipsApp: App {
    
    @State var type: EnterType = EnterType.podcast
    
    @State var query: String? = ""
    
    @State var podcast: RSSFeed?
    
    @State var episodeList: [Episode]?
    
    var body: some Scene {
        WindowGroup {
            ContentView(enterType: $type, query: $query)
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleEnter)
        }
    }
    
    func handleEnter(_ activity: NSUserActivity){
        guard let incomingURL = activity.webpageURL,
              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true)
              else {
            return       
        }
        switch components.path {
            case "/clips/podcast":
                self.type = EnterType.podcast
                break
            case "/clips/episode":
                self.type = EnterType.episode
                break
            default:
                self.type = EnterType.podcast
        }
        
        self.query = components.query
        let podId = query?.replacingOccurrences(of: "id=", with: "")
        FeedManager.shared.parser(rss: podId!)
    }
}
