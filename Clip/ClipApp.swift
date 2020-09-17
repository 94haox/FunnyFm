//
//  ClipApp.swift
//  Clip
//
//  Created by 吴涛 on 2020/8/18.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

@main
struct ClipApp: App {
    
    var chanel: Channel = Channel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(chanel)
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { (activity) in
                    guard let incomingURL = activity.webpageURL,
                          let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true)
                          else {
                        return
                    }
                    self.chanel.url = incomingURL.absoluteString
                }
        }
    }
}
