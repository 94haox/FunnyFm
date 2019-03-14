//
//  FMPlayerManager.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import MediaPlayer
import Kingfisher

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
    
    /// 播放器
    var player: AVPlayer?
    
    /// 播放资源
    var playerItem: AVPlayerItem?
    
    /// 当前时长
    var currentTime: NSInteger = 0
    
    /// 总时长
    var totalTime: NSInteger = 0
    
    var playState: MAudioPlayState = .waiting
    
    /// 倍数播放
    var ratevalue: Float = 0
    
    /// 当前资源文件
    var currentModel: Episode?
    
    override init() {
        super.init()
//        NotificationCenter.default.addObserver(self, selector: #selector(setBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reciveRemoteNotification(_:)), name: NSNotification.Name.init("FMREMOTECONTROLNOTIFICATION"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recivEndNotification(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
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
            let rate = UserDefaults.standard.float(forKey: "playrate")
            self.player?.rate = rate
        }else{
            SwiftNotice.noticeOnStatusBar("暂时无法播放", autoClear: true, autoClearTime: 1)
        }
    }
    
    func pause() {
        self.isPlay = false
        self.player?.pause()
        self.delegate?.playerDidPause()
		self.playerDelegate?.playerDidPause()
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
    
    @objc func reciveRemoteNotification(_ notify:Notification){
        let userInfo = notify.userInfo
        if userInfo.isSome {
            let action = userInfo!["action"]! as! String
            if action == "0" {
                self.pause()
            }
            
            if action == "1" {
                self.play()
            }
        }
    }
    
    @objc func recivEndNotification(_ notify: Notification){
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
                self.totalTime = NSInteger((self.playerItem?.duration.seconds)!)
                self.delegate?.managerDidChangeProgress(progess:time.seconds/(self.playerItem?.duration.seconds)!,currentTime: time.seconds, totalTime: (self.playerItem?.duration.seconds)!)
				self.playerDelegate?.managerDidChangeProgress(progess:time.seconds/(self.playerItem?.duration.seconds)!,currentTime: time.seconds, totalTime: (self.playerItem?.duration.seconds)!)
            }else{
                self.playerDelegate?.managerDidChangeProgress(progess: 0, currentTime: 0, totalTime: 0)
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
		var url = URL.init(string: chapter.trackUrl_high);
		var item : AVPlayerItem;
		if let episode = DatabaseManager.qurey(episodeId: chapter.episodeId) {
			url = self.completePath(episode)
			let asset = AVAsset.init(url: url!)
			item = AVPlayerItem.init(asset: asset)
		}else{
			item = AVPlayerItem.init(url: url!)
		}
        self.changePlayItem(item)
        if self.player.isNone {
            self.player = AVPlayer.init(playerItem: self.playerItem)
        }else{
            self.player?.replaceCurrentItem(with: self.playerItem)
        }
        self.addTimeObserver()
		
		if let progress = self.checkProgress(chapter) {
			self.seekToProgress(CGFloat(progress.progress))
		}
    }
	
	func completePath(_ episode: Episode) -> URL {
		let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let mp3Path = documentURL.appendingPathComponent("mp3")
		let url = mp3Path.appendingPathComponent(episode.download_filpath)
		return url;
	}
	
	func checkProgress(_ episode: Episode) -> ChapterProgress? {
		return DatabaseManager.qureyProgress(chapterId: episode.episodeId)
	}
    
}

// MARK: back

extension FMPlayerManager {
	
	@objc func setBackground() {
        let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: (self.currentModel?.pod_cover_url)!)
		var info = Dictionary<String, Any>()
		info[MPMediaItemPropertyTitle] = self.currentModel?.title//歌名
		info[MPMediaItemPropertyArtist] = self.currentModel?.pod_name//作者
        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(boundsSize: CGSize.init(width: 100, height: 100), requestHandler: { (size) -> UIImage in
            if image.isSome{
                return image!
            }
            return UIImage.init(named: "ImagePlaceHolder")!
        })
		info[MPMediaItemPropertyPlaybackDuration] = self.totalTime
		info[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.currentTime
		info[MPMediaItemPropertySkipCount] = NSNumber.init(value: 15)
		MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        UIApplication.shared.registerForRemoteNotifications()
	}
    
    
}
