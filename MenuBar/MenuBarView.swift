//
//  MenuBarView.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/8/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import AVFoundation

struct MenuBarView: View {
    
    @EnvironmentObject var playlistManager: PlayListManager
    
    var body: some View {
		VStack {
            PlayerToolBarView()
                .padding(.vertical, 12)
            PlayListView(playlist: playlistManager.playQueue)
        }
        
		
    }
}


