//
//  SpeechViewController.swift
//  ComponentList
//
//  Created by Duke on 2019/11/20.
//  Copyright © 2019 duke. All rights reserved.
//

import UIKit
import Speech

class SpeechViewController: UIViewController {

	@IBOutlet weak var loadingView: UIActivityIndicatorView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var rangeLB: UILabel!
	@IBOutlet weak var localBtn: UIButton!
	@IBOutlet weak var sttBtn: UIButton!
	@IBOutlet weak var convertTextView: UITextView!
    /// 播放器
    var player: AVPlayer?
    /// 播放资源
    var playerItem: AVPlayerItem?
	@IBOutlet weak var playBtn: UIButton!
	@IBOutlet weak var vSpaceConstraints: NSLayoutConstraint!
	
	var episode: Episode!
	var supportLocalListView: SupportLocalListView!
	var isRecing = false
	var startTime: Int = 0
	var cropUrl: URL?
	var localText: String = "en_US"
	
	deinit {
		
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.startTime = FMPlayerManager.shared.currentTime
		self.setUpUI()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.cropUrl = nil
		self.player?.pause()
		self.player = nil
		if SpeechManager.shared.myRecognizer.isSome {
			SpeechManager.shared.myRecognizer!.queue.cancelAllOperations()
		}
	}

	@IBAction func playAction(_ sender: UIButton) {
		
		if self.isRecing {
			return
		}
		
		if self.player.isNone {
			if self.cropUrl.isSome {
				self.playerItem = AVPlayerItem.init(url: self.cropUrl!)
				self.player = AVPlayer.init(playerItem: self.playerItem)
				self.player?.play()
				sender.isSelected = true
			}else{
				self.speech { [weak self]() in
					if (self?.cropUrl).isSome{
						self?.playerItem = AVPlayerItem.init(url: (self?.cropUrl)!)
						self?.player = AVPlayer.init(playerItem: self?.playerItem)
						self?.player?.play()
						DispatchQueue.main.async {
							sender.isSelected = true
						}
						
					}
				}
			}
		}else{
			if sender.isSelected {
				self.player?.pause()
				sender.isSelected = false
			}else{
				self.player?.play()
				sender.isSelected = true
			}
		}
		
		
	}
	
	
	@IBAction func changeLocalAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		self.supportLocalListView.snp.remakeConstraints { (make) in
			make.width.centerX.equalToSuperview()
			if sender.isSelected {
				make.top.equalTo(self.topView)
			}else{
				make.top.equalTo(self.view.snp.bottom)
			}
			make.bottom.equalTo(self.view.snp.bottom)
		}
		
		UIView.animate(withDuration: 0.2, delay: 0, options: .transitionFlipFromBottom, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	@IBAction func sttAction(_ sender: Any) {
		
		
		self.speech { () in
			
		}
		
	}
	
	func speech(complete: @escaping()->Void){
		self.vSpaceConstraints.constant = self.convertTextView.size.height + 100
		UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
		
		self.isRecing = true
		self.loadingView.isHidden = false;
		self.loadingView.startAnimating()
		if let episode = DatabaseManager.qureyDownload(title: self.episode.title) {
			let url =  FMPlayerManager.shared.completePath(episode)
			if self.cropUrl.isSome {
				SpeechManager.shared.recognizeFile(url: self.cropUrl!, local: self.localText, startTime: startTime) { (text, filePath) in
					self.config(text: text, filePath: filePath)
					complete()
				}
			}else{
				SpeechManager.shared.recognizeFile(url: url, local: self.localText, startTime: startTime) { (text, filePath) in
					self.config(text: text, filePath: filePath)
					complete()
				}
			}
		}
	}
	
	func config(text: String?, filePath: String?) {
		if filePath.isSome{
			self.cropUrl = URL.init(fileURLWithPath: filePath!)
		}
		DispatchQueue.main.async {
			self.loadingView.isHidden = true
			self.convertTextView.text = text
			self.isRecing = false
		}
	}

}

extension SpeechViewController {
	
	func setUpUI(){
        self.view.backgroundColor = CommonColor.white.color
		self.convertTextView.isEditable = false
		
		self.rangeLB.text = "\(Date.formatIntervalToMM(startTime)) - \(Date.formatIntervalToMM(startTime+60))"
		
		self.topView.layer.cornerRadius = 5
		self.topView.layer.masksToBounds = true
		self.loadingView.isHidden = true;
		self.sttBtn.layer.cornerRadius = 5
		
		self.supportLocalListView = SupportLocalListView.init(frame: CGRect.zero)
		self.supportLocalListView.layer.cornerRadius = 5
		self.supportLocalListView.clipsToBounds = true
		self.view.addSubview(self.supportLocalListView);
		
		self.supportLocalListView.snp.remakeConstraints { (make) in
			make.width.centerX.equalToSuperview()
			if self.localBtn.isSelected {
				make.top.equalTo(self.topView)
			}else{
				make.top.equalTo(self.view.snp.bottom)
			}
			make.bottom.equalTo(self.view.snp.bottom)
		}
		self.supportLocalListView.changeLocalClosure = { (title, value) in
			self.localBtn.setTitle(title, for: .normal)
			self.changeLocalAction(self.localBtn)
			self.localText = value
		}
	
	}
	
}
