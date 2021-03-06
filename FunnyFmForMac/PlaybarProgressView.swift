//
//  PlaybarProgressView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct PlaybarProgressView: View {
    
    @EnvironmentObject private var playState: PlayState
    
    @State var isDragging = false

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                print(value)
                self.isDragging = true
            }
            .onEnded { _ in self.isDragging = false }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                if playState.playerStatus == .failed ||
                   playState.playerStatus == .loading ||
                    playState.playerStatus == .ready {
                    Text("00:00")
                        .foregroundColor(Color.gray)
                    Text("--:--")
                        .foregroundColor(Color.gray)
                } else {
                    Text(Date.formatIntervalToMM(playState.currentTime))
                    Text(Date.formatIntervalToMM(playState.totalTime))
                        .foregroundColor(Color.gray)
                }
            }
        }
        .gesture(drag)
    }
}

struct PlaybarProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybarProgressView()
    }
}
