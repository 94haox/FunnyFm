//
//  PlayListView.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/9/4.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct PlayListView: View {
    
    @State var playlist: [Episode]
    
    var body: some View {
        ForEach(playlist) { item in
            if item.id != FMPlayerManager.shared.currentModel?.id {
                EpisodeItemView(episode: item)
            }
        }
    }
}

