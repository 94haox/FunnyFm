//
//  MenuBarApp.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/8/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import CoreSpotlight

@main
struct MenuBarApp: App {
    var body: some Scene {
		WindowGroup {
			MenuBarView()
				.onContinueUserActivity("com.duke.www.FunnyFm", perform: handleContinue )
				.onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlight)
				.frame(width: 300, alignment: .leading)
				.background(Color.white)
				
		}
    }
	
	func handleContinue(_ activity: NSUserActivity) {
		guard let userInfo = activity.userInfo else {
			return
		}
		
		if let data = userInfo["episode"] as? Data {
			let episode = Episode.init(data: data)
			HandoffManager.shared.currentEpisode = episode
		}
	}
	
	func handleSpotlight(_ userActivity: NSUserActivity) {
		if let id = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
			print("Found identifier \(id)")
		}
	}
	
}

struct MenuBarApp_Previews: PreviewProvider {
	static var previews: some View {
		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
	}
}
