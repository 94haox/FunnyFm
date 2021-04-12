//
//  PlayState.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/11.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

enum PlayerStatus {
    case loading
    case ready
    case playing
    case pause
    case stop
    case failed
}

protocol PlayStateManagerDelegate {
    func playerStatusDidChanged()
    func playerStatusDidFailure()
    func playerDidPlay()
    func playerDidPause()
    func managerDidChangeProgress(progess:Double, currentTime: Double, totalTime: Double)
}


class PlayState: NSObject, ObservableObject {
    
    static let shared = PlayState()
    
    @Published var currentItem: Episode?
    
    @Published var playerStatus: PlayerStatus = .failed
    
    /// 播放倍速
    @Published var playRate: Float = PlaySettings.shared.defultRate
    
    /// 当前时长
    @Published var currentTime: Int = 0
    
    /// 总时长
    @Published var totalTime: Int = 0
    
    @Published var playState: PlayerStatus = .loading
    
    @Published var lastTime: Double = 0
    
    private var timerObserver: Any?
    
    /// 播放器
    private var player: AVPlayer?
    
    /// 播放资源
    private var playerItem: AVPlayerItem?
    
    override init() {
        super.init()
        if let ep = CDEpisode.fetchOne(with: PlayList.shared.lastItemTrackUrl) {
            self.config(ep)
        }
    }
    
}


// MARK: playControll

extension PlayState {
    
    /// 开始播放
    func play(){
        guard playerStatus != .failed else {
            return
        }
        if playerStatus == .playing {
            pause()
            return
        }
        
        playerStatus = .playing
        player?.play()
        player?.rate = playRate
    }
    
    func pause() {
        self.playerStatus = .pause
        self.player?.pause()
    }
    
    func updateProgress() {
        if self.currentItem == nil {
            return;
        }
        var progress = Double(self.currentTime)
        
        if progress > 5 {
            progress = progress - 5
        }
    }
    
    func seekToProgress(_ progress: CGFloat) {
        if self.playerItem == nil {
            return;
        }
        self.player?.pause()
        self.player?.removeTimeObserver(self.timerObserver!)
        let seekSecond = self.playerItem!.duration.seconds * Double(progress)
        let seekTime = CMTimeMakeWithSeconds(seekSecond, preferredTimescale: 1*600)
        self.player?.seek(to: seekTime, completionHandler: { [weak self] (isComplete) in
            guard let self = self else {return}
            if self.playerStatus == .playing {
                self.player?.play()
            }
            self.addTimeObserver()
        })
    }
    
    func seekAdditionSecond(_ time: Double){
        guard let _ = self.playerItem else {
            return
        }
        let skiptime = (self.player?.currentTime().seconds)! + time
        self.seekToTime(skiptime)
    }
    
    private func seekToTime(_ time:Double) {
        guard let _ = self.playerItem else {
            return
        }
        self.player?.pause()
        self.player?.removeTimeObserver(self.timerObserver!)
        let seekTime = CMTimeMakeWithSeconds(time, preferredTimescale:600)
        self.player?.seek(to: seekTime, completionHandler: { [weak self] (isComplete) in
            guard let self = self else {return}
            if(self.playerStatus == .playing){
                self.player?.play()
                self.addTimeObserver()
            }
        })
    }
    
    @objc func audioInterruptionAction() {
        self.pause()
    }
    
    @objc func recivEndNotification(_ notify: Notification){
        guard let _ = self.playerItem else {
            return
        }
        
        self.seekToProgress(0)
        
        self.pause()
    }
    
}


// MARK: observers

extension PlayState {
    
    func addTimeObserver(){
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        self.timerObserver = self.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (time) in
            guard let self = self else {return}
            if time.seconds > 0,
               (self.playerItem?.duration.seconds).isSome {
                
                self.currentTime = NSInteger(time.seconds)
                self.totalTime = Int((self.playerItem?.duration.seconds)!)
                self.updateProgress()
            }else{
                self.updateProgress()
            }
        })
    }
}

// MARK: config

extension PlayState {
    
    func changePlayItem(_ item: AVPlayerItem){
        self.pause()
        self.currentTime = 0
        self.totalTime = 0
        self.playerStatus = .loading
        self.playerItem?.removeObserver(self, forKeyPath: "status")
        self.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.playerItem = item
        self.playerStatus = .loading
        UserDefaults.standard.set(1.0, forKey: "playrate")
        UserDefaults.standard.synchronize()
        self.playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)

    }
    
    func config(_ chapter:Episode) {
        PlayList.shared.lastItemTrackUrl = chapter.trackUrl
        self.currentItem = chapter
        let url = URL(string: chapter.trackUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!);
        let item = AVPlayerItem(url: url!)
    
//        self.lastTime = self.checkProgress(chapter)
        self.changePlayItem(item)
        if self.player.isNone {
            self.player = AVPlayer.init(playerItem: self.playerItem)
        }else{
            self.player?.replaceCurrentItem(with: self.playerItem)
        }
        self.addTimeObserver()
    }
}

extension PlayState {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let value = change?[NSKeyValueChangeKey.newKey]
        if value.isNone {
            return
        }
        
        if keyPath == "status"{
            if self.playerItem.isNone {
                return
            }
            
            if self.playerItem!.status != .readyToPlay {
                print("音频初始化失败，请重试")
                self.playerStatus = .failed
            }else{
                self.playerStatus = .ready
            }
        }
        
        if keyPath == "loadedTimeRanges" {
            if self.lastTime < 1 {
                return
            }
            let timeRanges = self.playerItem!.loadedTimeRanges
            let timeRange = timeRanges.first!.timeRangeValue
            let duration = timeRange.duration.seconds
            if self.lastTime < duration {
                self.seekToTime(self.lastTime)
                self.lastTime = 0
            }
        }
        
    }
    
}

