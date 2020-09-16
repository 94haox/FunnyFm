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
        
    var playlistManager: PlayListManager = PlayListManager.shared
    
    @State var selected: FunnyMenu = FunnyMenu.now
    
    @State var isEmpty: Bool = true
    
    var body: some Scene {
        WindowGroup {
            
            NavigationView{
                    SlideItemsView(selected: $selected)
                        .frame(minWidth: 120, minHeight: 300)
                    Group{
                        
                        if selected == FunnyMenu.playList {
                            PlayContentView()
                                .environmentObject(playlistManager)
                        }else if selected == FunnyMenu.discovery {
                            EmptyView()
                                .onAppear(){
                                    isEmpty = DatabaseManager.allEpisodes(limit: 1).count < 1
                                }
                        }
                    }
                    .onContinueUserActivity("com.duke.www.FunnyFm", perform: handleContinue )
                    .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlight)
                    .frame(minWidth:400)
                }
                .background(Color.white.opacity(0.9))
        }
        .windowStyle(HiddenTitleBarWindowStyle())

        Settings {
            SettingView()
        }

    }
	
	func handleContinue(_ activity: NSUserActivity) {
		guard let userInfo = activity.userInfo else {
			return
		}
		
		if let data = userInfo["episode"] as? Data {
			let episode = Episode.init(data: data)
            playlistManager.queueIn(episode: episode)
            DatabaseManager.addEpisode(episode: episode)
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
