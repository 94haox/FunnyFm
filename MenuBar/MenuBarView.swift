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
			Group{
				Divider()
				List{
					
				}
			}
		}
		
    }
}


