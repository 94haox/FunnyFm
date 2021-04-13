//
//  EpisodeView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct EpisodeView: View {

    let episode: Episode?
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(episode?.title ?? "")
                Spacer()
            }
            Spacer()
        }
        .frame(width: 100)
        .background(Color.white)
        .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
        .onAppear(perform: {
       })
        .navigationTitle(episode?.title ?? "")
    }
}
