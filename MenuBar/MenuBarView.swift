//
//  MenuBarView.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/8/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import AVFoundation


var audioPlayer: AVAudioPlayer!

struct MenuBarView: View {
	
	@StateObject var manager: HandoffManager = HandoffManager.shared
	
    
    
    var body: some View {
		VStack {
			CurrentPlayView(episode: manager.currentEpisode)
                .padding(.vertical, 12)
            if PlayListManager.shared.playQueue.count > 1 {
                Divider()
                List{
                    ForEach.init(PlayListManager.shared.playQueue) { item in
                        if item.id != FMPlayerManager.shared.currentModel?.id {
                            EpisodeItemView(episode: item)
                                .frame(height: 60)
                        }
                    }
                }
            }
		}
		
    }
}


