//
//  MenuBarView.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/8/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import AVFoundation

struct PlayContentView: View {
    
    
    @EnvironmentObject var playlistManager: PlayListManager
    
    @State var playQueue: [Episode] = DatabaseManager.allEpisodes(limit: 50)
    
    var body: some View {
        PlayListView(playlist: $playQueue)
            .frame(minHeight: 200)
            .onAppear(){
                self.playQueue = DatabaseManager.allEpisodes(limit: 50)
            }
    }
}


