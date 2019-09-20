//
//  FMPlayerManager.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import MediaPlayer
import Nuke

enum MAudioPlayState {
    case playing
    case paused
    case waiting
}

protocol FMPlayerManagerDelegate {
    func playerStatusDidChanged(isCanPlay:Bool)
	func playerDidPlay()
	func playerDidPause()
    func managerDidChangeProgress(progess:Double, currentTime: Double, totalTime: Double)
}

class FMPlayerManager: NSObject {
    
    static let shared = FMPlayerManager()
    
    var delegate: FMPlayerManagerDelegate?
	
	var playerDelegate: FMPlayerManagerDelegate?
    
    /// 事件观察者
    var timerObserver: Any?
    
    /// 是否在播放状态
    var isPlay: Bool = false
    
    var isFirst: Bool = true
    
    /// 资源是否成功加载
    var isCanPlay: Bool = false
	
	/// 播放倍速
	var playRate: Float = 1
	
    /// 播放器
    var player: AVPlayer?
    
    /// 播放资源
    var playerItem: AVPlayerItem?
    
    /// 当前时长
    var currentTime: NSInteger = 0
    
    /// 总时长
    var totalTime: Double = 0
    
    var playState: MAudioPlayState = .waiting
	
	var lastTime: Double = 0
    
    /// 当前资源文件
    var currentModel: Episode?
	
	var sleepTimer: Timer? = nil
	
	var isSleepTimerActive = false
    
    override init() {
        super.init()
		
        NotificationCenter.default.addObserver(self, selector: #selector(recivEndNotification(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
		self.addRemoteCommand()
    }
    
    deinit {
        self.playerItem?.removeObserver(self, forKeyPath: "status")
        self.player?.removeTimeObserver(self.timerObserver!)
        NotificationCenter.default.removeObserver(self)
    }
	

}


// MARK: playControll

extension FMPlayerManager {
    
    /// 开始播放
    func play(){
        if(self.isCanPlay){
            self.isPlay = true
            self.player?.play()
            self.delegate?.playerDidPlay()
			self.playerDelegate?.playerDidPlay()
            self.player?.rate = self.playRate
        }else{
            SwiftNotice.noticeOnStatusBar("暂时无法播放".localized, autoClear: true, autoClearTime: 1)
        }
    }
    
    func pause() {
        self.isPlay = false
        self.player?.pause()
        self.delegate?.playerDidPause()
		self.playerDelegate?.playerDidPause()
    }
	
	func updateProgress() {
		if self.currentModel.isNone {
			return;
		}
		
		var progress = Double(self.currentTime)
		
		if progress > 5 {
			progress = progress - 5
		}
		
		DatabaseManager.updateProgress(progress: progress, episodeId: self.currentModel!.title)
	}
    
    func seekToProgress(_ progress: CGFloat) {
        if self.playerItem.isNone {
            return;
        }
        self.player?.pause()
        self.player?.removeTimeObserver(self.timerObserver!)
        let seekSecond = self.playerItem!.duration.seconds * Double(progress)
        let seekTime = CMTimeMakeWithSeconds(seekSecond, preferredTimescale: 1*600)
        self.player?.seek(to: seekTime, completionHandler: { [unowned self] (isComplete) in
            if(self.isPlay){
                self.player?.play()
            }
            self.addTimeObserver()
            self.setBackground()
        })
    }
	
	func seekAdditionSecond(_ time: Double){
		if self.playerItem.isNone {
			return
		}
		let skiptime = (self.player?.currentTime().seconds)! + time
		self.seekToTime(skiptime)
	}
	
	func seekToTime(_ time:Double) {
		if self.playerItem.isNone {
			return;
		}
		self.player?.pause()
		self.player?.removeTimeObserver(self.timerObserver!)
		let seekTime = CMTimeMakeWithSeconds(time, preferredTimescale:600)
		self.player?.seek(to: seekTime, completionHandler: { [unowned self] (isComplete) in
			if(self.isPlay){
				self.player?.play()
			}
			self.addTimeObserver()
			self.setBackground()
		})
	}
	
    @objc func recivEndNotification(_ notify: Notification){
		if self.playerItem.isNone || self.delegate.isNone {
			return;
		}
        self.seekToProgress(0)
        self.delegate?.managerDidChangeProgress(progess: 0, currentTime: 0, totalTime: (self.playerItem?.duration.seconds)!)
		self.playerDelegate?.managerDidChangeProgress(progess: 0, currentTime: 0, totalTime: (self.playerItem?.duration.seconds)!)
        self.pause()
    }
    
}


// MARK: observers

extension FMPlayerManager{
	
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let value = change?[NSKeyValueChangeKey.newKey]
        if value.isNone {
            return
        }
        if keyPath == "status" {
            let status = value! as! Int
            self.isCanPlay = status == 1
            self.delegate?.playerStatusDidChanged(isCanPlay: self.isCanPlay)
			self.playerDelegate?.playerStatusDidChanged(isCanPlay: self.isCanPlay)
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
    
    func addTimeObserver(){
        self.timerObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime.init(seconds: 0.1, preferredTimescale: 600), queue: DispatchQueue.main, using: { [unowned self] (time) in
            if(time.seconds > 0 && (self.playerItem?.duration.seconds).isSome){
                if(time.seconds == 0){
                    self.delegate?.managerDidChangeProgress(progess: 0, currentTime: 0, totalTime: (self.playerItem?.duration.seconds)!)
					self.playerDelegate?.managerDidChangeProgress(progess: 0, currentTime: 0, totalTime: (self.playerItem?.duration.seconds)!)
                }
                self.currentTime = NSInteger(time.seconds)
                self.totalTime = (self.playerItem?.duration.seconds)!
                self.delegate?.managerDidChangeProgress(progess:time.seconds/(self.playerItem?.duration.seconds)!,currentTime: time.seconds, totalTime: (self.playerItem?.duration.seconds)!)
				self.playerDelegate?.managerDidChangeProgress(progess:time.seconds/(self.playerItem?.duration.seconds)!,currentTime: time.seconds, totalTime: (self.playerItem?.duration.seconds)!)
				self.updateProgress()
            }else{
                self.playerDelegate?.managerDidChangeProgress(progess: 0, currentTime: 0, totalTime: 0)
				self.updateProgress()
            }
            self.setBackground()
        })
    }
}


// MARK: config

extension FMPlayerManager {
    
    func changePlayItem(_ item: AVPlayerItem){
        self.isCanPlay = false
        self.delegate?.playerStatusDidChanged(isCanPlay: false)
		self.playerDelegate?.playerStatusDidChanged(isCanPlay: false)
        self.playerItem?.removeObserver(self, forKeyPath: "status")
        self.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.playerItem = item
        UserDefaults.standard.set(1.0, forKey: "playrate")
        UserDefaults.standard.synchronize()
        self.playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
    }
    
    func config(_ chapter:Episode) {
        if(self.currentModel != nil){ self.isFirst = false}
        self.currentModel = chapter
        configPlayBackgroungMode()
        self.setBackground()
		var url = URL.init(string: chapter.trackUrl);
		var item : AVPlayerItem;
		if let episode = DatabaseManager.qureyDownload(title: chapter.title) {
			url = self.completePath(episode)
			let asset = AVAsset.init(url: url!)
			item = AVPlayerItem.init(asset: asset)
		}else{
			item = AVPlayerItem.init(url: url!)
		}
		self.lastTime = self.checkProgress(chapter)
        self.changePlayItem(item)
        if self.player.isNone {
            self.player = AVPlayer.init(playerItem: self.playerItem)
        }else{
            self.player?.replaceCurrentItem(with: self.playerItem)
        }
        self.addTimeObserver()
    }
	
	func completePath(_ episode: Episode) -> URL {
		let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let mp3Path = documentURL.appendingPathComponent("mp3")
		let url = mp3Path.appendingPathComponent(episode.download_filpath)
		return url;
	}
	
	func checkProgress(_ episode: Episode) -> Double {
		return DatabaseManager.qureyProgress(episodeId: episode.title)
	}
    
}

extension FMPlayerManager {
	
	func startSleep(seconds: Int) {
		
		self.isSleepTimerActive = true
		
		var count = 0
		sleepTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
			count = count + 1
			if count == seconds {
				if self.isPlay {
					self.pause()
				}
				self.sleepTimer!.invalidate()
				self.isSleepTimerActive = false
			}
		}
		sleepTimer!.fire()
	}
	
	func cancelSleep(){
		if let _ = sleepTimer {
			sleepTimer!.invalidate()
			self.isSleepTimerActive = false
		}
	}
	
}



// MARK: back

extension FMPlayerManager {
	
	func addRemoteCommand() {
		MPRemoteCommandCenter.shared().skipBackwardCommand.preferredIntervals = [15.0]
		MPRemoteCommandCenter.shared().skipForwardCommand.preferredIntervals = [15.0]
		MPRemoteCommandCenter.shared().skipForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
			self.seekAdditionSecond(15)
			return .success
		}
		
		MPRemoteCommandCenter.shared().skipBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
			self.seekAdditionSecond(-15)
			return .success
		}
		
		MPRemoteCommandCenter.shared().playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
			self.play()
			return .success
		}
		
		MPRemoteCommandCenter.shared().pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
			self.pause()
			return .success
		}
	}
	
	@objc func setBackground() {
		let request = ImageRequest(url: URL.init(string: (self.currentModel?.coverUrl)!)!)
		let image = ImageCache.shared[request]
		var info = Dictionary<String, Any>()
		info[MPMediaItemPropertyTitle] = self.currentModel?.title//歌名
		info[MPMediaItemPropertyArtist] = self.currentModel?.author//作者
        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(boundsSize: CGSize.init(width: 100, height: 100), requestHandler: { (size) -> UIImage in
            if image.isSome{
                return image!
            }
            return UIImage.init(named: "ImagePlaceHolder")!
        })
		info[MPNowPlayingInfoPropertyAssetURL] = URL.init(string: self.currentModel!.trackUrl)
		info[MPMediaItemPropertyPlaybackDuration] = self.totalTime
		info[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.currentTime
		info[MPMediaItemPropertySkipCount] = NSNumber.init(value: 15)
		MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        UIApplication.shared.registerForRemoteNotifications()
		
	}
    
    
}
