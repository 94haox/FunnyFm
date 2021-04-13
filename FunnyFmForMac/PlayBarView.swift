//
//  PlayBarView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct PlayBarView: View {
    
    @EnvironmentObject private var playState: PlayState
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                PlaybarInfo(episode: playState.currentItem)
                    .padding(.horizontal, 32)
                PlaybarControlView()
                    .environmentObject(playState)
                    .padding(.horizontal, 32)
                PlaybarProgressView()
                    .environmentObject(playState)
                Spacer()
                HStack {
                    Image(systemName: "circle.grid.2x2")
                        .font(.largeTitle)
                }
                .padding(.horizontal, 32)
            }
            Spacer()
        }
        
    }
}

struct PlaybarControlView: View {
    
    @EnvironmentObject private var playState: PlayState
    
    @State private var loading: Bool = true
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "gobackward.15")
                .font(.title3)
                .onTapGesture {
                    playState.seekAdditionSecond(-15)
                }
            HStack {
                if playState.playerStatus == .playing {
                    Image(systemName: "pause.circle.fill")
                        .font(.largeTitle)
                } else if playState.playerStatus == .loading {
                    Indicator(shown: $loading)
                } else if playState.playerStatus == .failed {
                    Image(systemName: "play.slash.fill")
                        .font(.largeTitle)
                }  else {
                    Image(systemName: "play.circle.fill")
                        .font(.largeTitle)
                }
            }
            .onTapGesture {
                playState.play()
            }
            Image(systemName: "goforward.30")
                .font(.title3)
                .onTapGesture {
                    playState.seekAdditionSecond(30)
                }
        }
    }
}

struct Indicator: View {

    @Binding var shown: Bool
    @State private var rotating = false
    var imageName: String = "arrow.triangle.2.circlepath"
    
    var body: some View {
        if shown {
            Image(systemName: imageName)
                .font(.title)
                .rotationEffect(.degrees(rotating ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.easeInOut.repeatForever()) {
                        self.rotating = true
                    }
                }
        }
    }
}

struct PlayBarView_Previews: PreviewProvider {
    static var previews: some View {
        PlayBarView()
    }
}
