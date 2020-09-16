//
//  PlayerToolBarView.swift
//  MenuBar
//
//  Created by Tao on 2020/9/2.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct PlayerToolBarView: View {
    
    @State var playProgress: Double = 0
    @State var isHover: Bool = false
    @ObservedObject var playManager: FMPlayerManager
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    HStack(spacing: 12){
                        Image(systemName: "shuffle")
                        Image(systemName: "repeat")
                    }
                    .font(.title2)
                    .padding(.leading, 16)
                    Spacer()
                    HStack(spacing: 18){
                        Image(systemName: "gobackward.15")
                            .foregroundColor(Color.gray)
                            .onTapGesture {
                                playManager.seekAdditionSecond(-15)
                            }
                        VStack {
                            if playManager.isCanPlay {
                                HStack {
                                    if playManager.isPlay {
                                        Image(systemName: "pause.fill")
                                            .foregroundColor(Color.accentColor)
                                            .onTapGesture {
                                                playManager.pause()
                                            }
                                    }else{
                                        Image(systemName: "play.fill")
                                            .foregroundColor(Color.accentColor)
                                            .onTapGesture {
                                                playManager.play()
                                            }
                                    }
                                }
                                .frame(width: 50, height: 35)
                                .background(isHover ? Color.accentColor.opacity(0.1): Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .onHover { (hovered) in
                                    isHover = hovered
                                }
                            }else{
                                ProgressView()
                                    .progressViewStyle(DarkBlueShadowProgressViewStyle())
                            }
                        }
                        Image(systemName: "goforward.15")
                            .foregroundColor(Color.gray)
                            .onTapGesture {
                                FMPlayerManager.shared.seekAdditionSecond(15)
                            }
                    }
                    .font(.title2)
                    Spacer()
                    HStack {
                        Text("\(playManager.playRate)x")
                            .font(.title3)
                    }
                    .onTapGesture {
                        self.changeRateAction()
                    }
                    .padding(.trailing, 16)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
                VStack {
                    Spacer()
                    ProgressView(value: playProgress)
                }
            }
        }
        .onAppear(){
            playManager.delegate = self
        }
    }
}

extension PlayerToolBarView: FMPlayerManagerDelegate {
    
    func changeRateAction(){
        var rate = 1.0;
        switch playManager.playRate {
        case 0.5:
            rate = 0.8
            break
        case 0.8:
            rate = 1.0
            break
        case 1.0:
            rate = 1.25
            break
        case 1.25:
            rate = 1.5
        break
        case 1.5:
            rate = 2
            break
        case 2:
            rate = 0.5
            break
        default:
            break
        }
        
        FMPlayerManager.shared.playRate = Float(rate)
        FMPlayerManager.shared.player?.rate = Float(rate)
    }
    
    func playerStatusDidChanged(isCanPlay: Bool) {
        if isCanPlay {
            playManager.play()
        }
    }
    
    func playerStatusDidFailure() {
    }
    
    func playerDidPlay() {
    }
    
    func playerDidPause() {
    }
    
    func managerDidChangeProgress(progess: Double, currentTime: Double, totalTime: Double) {
        self.playProgress = progess
    }
    
    
}

struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .shadow(color: Color.accentColor, radius: 4.0, x: 1.0, y: 2.0)
            .controlSize(ControlSize.small)
    }
}

