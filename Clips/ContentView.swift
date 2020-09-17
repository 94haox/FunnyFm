//
//  ContentView.swift
//  Clips
//
//  Created by 吴涛 on 2020/9/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var enterType: EnterType
    
    @Binding var query: String?
    
    var body: some View {
        if enterType == EnterType.episode {
            EpisodeInfoView(query: query)
        }
        
        if enterType == EnterType.podcast {
            PodcastDetaliView()
        }
    }
}

