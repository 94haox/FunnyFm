//
//  SubPodcastView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/13.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct SubPodcastView: View {
    
    let podcast: GPodcast
    
    @State private var isHover: Bool = false
    
    var body: some View {
        VStack {
            FFImageView(urlString: podcast.artwork_url)
                .frame(width: 100, height: 100)
                .cornerRadius(15)
                .padding(.top, isHover ? 0 : 12)
                .padding(.bottom, 4)
            Text(podcast.track_name)
                .font(.headline)
                .frame(maxWidth: 100)
        }
        .onHover { (isHover) in
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                self.isHover = isHover
            }
        }
    }
}
