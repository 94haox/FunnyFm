//
//  PodcastInfoView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/13.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI


struct PodcastInfoView: View {
    @Binding var podcast: GPodcast?
    
    @State var width: CGFloat = 0
    
    var body: some View {
        if podcast == nil {
            Text("")
        } else {
            VStack {
                HStack {
                    Spacer()
                    Text(podcast!.track_name)
                    Spacer()
                }
                Spacer()
            }
            .background(Color.white)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 0)
        }
    }
}
