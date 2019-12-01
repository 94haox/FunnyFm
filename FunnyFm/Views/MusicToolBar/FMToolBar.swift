//
//  FmToolBar.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import MediaPlayer
import RxSwift
import pop

let toolbarH: CGFloat = 55

class FMToolBar: UIView , FMPlayerManagerDelegate{

    static let shared = FMToolBar(frame: CGRect.init(x: 16, y: kScreenHeight-150, width: kScreenWidth-32 , height: toolbarH))
	
	var isPlaying: Bool = false
	
	var isStart: Bool = false
	
    var isShrink: Bool = false
	
	var bottomInset: CGFloat = 0 {
		didSet {
			FMToolBar.shared.explain()
		}
	}
    
    var currentEpisode: Episode?
    
    var containerView: UIView!
    
    var playBtn : UIButton!
    
    var titleLB : UILabel!
    
    var logoImageView : UIImageView!
    
    var loadingView: UIActivityIndicatorView!
	
	var tapGes: UITapGestureRecognizer!
	
	let progressBg = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
        self.addConstraints()
		self.tapGes = UITapGestureRecognizer.init(target:self, action: #selector(toPlayDetailVC))
		self.containerView.addGestureRecognizer(self.tapGes)
		self.progressBg.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	func toPlayDetailView(){
		let vc = PlayerDetailViewController()
		vc.episode = self.currentEpisode
		let nav = UIApplication.shared.keyWindow?.rootViewController
		let presentNavi = UINavigationController.init(rootViewController: vc)
		presentNavi.navigationBar.isHidden = true
		presentNavi.modalPresentationStyle = .fullScreen
//		nav?.dw_presentAsStork(controller: presentNavi, heigth: kScreenHeight, delegate: nav)
		nav?.present(presentNavi, animated: true, completion: nil)
	}
    
	@objc func toPlayDetailVC(){
		if !FMPlayerManager.shared.isCanPlay{
            return
        }
        self.toPlayDetailView()
	}
}

// MARK: action
extension FMToolBar {
	
	func toobarPause(){
		FMPlayerManager.shared.delegate = self
		FMPlayerManager.shared.pause()
	}
	
	func toolbarPlay(){
		FMPlayerManager.shared.delegate = self
		FMPlayerManager.shared.play()
	}
	
	
}


// MARK: FMPlayerManagerDelegate
extension FMToolBar {
    
    @objc func didTapPlayBtnAction(btn:UIButton){
        btn.isSelected = !self.playBtn.isSelected
        if btn.isSelected {
			if FMPlayerManager.shared.currentModel.isNone {
				if self.currentEpisode.isSome {
					FMPlayerManager.shared.config(self.currentEpisode!)
					return
				}
			}
            FMPlayerManager.shared.play()
        }else{
            FMPlayerManager.shared.pause()
			self.isPlaying = false
        }
    }
	
    
    func playerStatusDidChanged(isCanPlay: Bool) {
        self.loadingView.isHidden = isCanPlay
        self.playBtn.isHidden = !isCanPlay
		if isCanPlay && !self.isStart{
			self.playBtn.isSelected = true
			FMPlayerManager.shared.play()
		}
    }
	
	func playerDidPlay() {
		self.isPlaying = true
	}
	
	func playerDidPause() {
		self.isPlaying = false
		self.playBtn.isSelected = false
	}
    
    func managerDidChangeProgress(progess: Double, currentTime: Double, totalTime: Double) {
		var frame = self.progressBg.frame
		frame.size.width = self.containerView.width * CGFloat(progess)
		UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
			self.progressBg.frame = frame
		}, completion: nil)
    }
}


extension FMToolBar{
    
    
    func configToolBarAtHome(_ episode : Episode) {
		self.isHidden = false
		self.explain()
        self.config(episode, url: episode.coverUrl)
		self.setUpChapter(episode)
    }
    
    func configToolBar(_ episode : Episode) {
        self.config(episode,url: episode.coverUrl)
		self.setUpChapter(episode)
    }
    
	func config(_ chapter: Episode, url: String){
		self.isStart = false
		PlayListManager.shared.queueInsert(episode: chapter)
        self.isHidden = false
        if self.currentEpisode.isNone {
           self.currentEpisode = chapter
        }else{
            if self.currentEpisode?.title == chapter.title  && self.isPlaying{
				SwiftNotice.noticeOnStatusBar("正在播放".localized, autoClear: true, autoClearTime: 2)
                return
            }
            DatabaseManager.add(history: chapter)
            self.currentEpisode = chapter
        }
		self.progressBg.frame = CGRect.init(x: 0, y: 0, width: 0, height: self.height)
        self.titleLB.text = chapter.title
//        self.authorLB.text = chapter.author
		self.logoImageView.loadImage(url: (self.currentEpisode?.coverUrl)!, placeholder: nil) {[unowned self] (image) in
			self.configShadowColor()
		}

    }
	
	func configAtStart(episode: Episode){
		self.config(episode, url: episode.coverUrl)
		self.isStart = true
		self.setUpChapter(episode)
	}
    
    func configShadowColor() {
        let color = self.logoImageView.image!.mostColor()
        self.logoImageView.layer.shadowColor = color!.cgColor
    }
    
    func setUpChapter(_ chapter: Episode){
        FMPlayerManager.shared.pause()
        self.playBtn.isSelected = false
        FMPlayerManager.shared.config(chapter)
        FMPlayerManager.shared.delegate = self
    }
    
}


extension FMToolBar {
    
    
    
    func shrink(){
		
        let animationTime = 0.3
	
        UIView.animate(withDuration: animationTime, animations: {
			self.frame = CGRect.init(x: 16, y: kScreenHeight - toolbarH - self.bottomInset, width: kScreenWidth - 32, height: toolbarH)
        }) { (isComplete) in
            self.isShrink = true
        }
    }
    
    func explain() {

        let animationTime = 0.3
		
        UIView.animate(withDuration: animationTime, animations: {
			self.frame = CGRect.init(x: 16, y: kScreenHeight - toolbarH*2 - self.bottomInset - 12, width: kScreenWidth-24, height: toolbarH)
        }) { (isComplete) in
            self.containerView.isHidden = false
            self.isShrink = false
        }
        
    }
    
}


extension FMToolBar {
    
    func addConstraints() {
        self.backgroundColor = .white
        self.cornerRadius = 8.0
        self.addShadow(ofColor: UIColor.lightGray, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 0.5)
        self.addSubview(self.containerView)
        self.addSubview(self.logoImageView)
        self.containerView.addSubview(self.titleLB)
        self.addSubview(self.playBtn)
        self.addSubview(self.loadingView)
		
		
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.titleLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.logoImageView.snp.right).offset(16)
            make.width.equalTo(AdaptScale(200))
			make.centerY.equalToSuperview()
        }
        
        self.logoImageView.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        
        self.loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(self.playBtn)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        self.playBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.logoImageView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.right.equalToSuperview().offset(-10)
        }
		
		
    }
	
    func setUpUI() {
		
        self.containerView = UIView()
		self.containerView.cornerRadius = 8.0
		self.containerView.layer.masksToBounds = true
		
		self.playBtn = UIButton.init(type: .custom)
        self.playBtn.setImage(UIImage.init(named: "play-red"), for: .normal)
        self.playBtn.setImage(UIImage.init(named: "pause-red"), for: .selected)
        self.playBtn.backgroundColor = .white
        self.playBtn.cornerRadius = 15
        self.playBtn.isHidden = true
        self.playBtn.addTarget(self, action: #selector(didTapPlayBtnAction(btn:)), for: .touchUpInside)
                
        self.titleLB = UILabel.init()
        self.titleLB.font = p_bfont(12)
        self.titleLB.textColor = CommonColor.title.color
        
        self.logoImageView = UIImageView.init()
        self.logoImageView.layer.cornerRadius = 5;
        self.logoImageView.layer.shadowOpacity = 0.5
        self.logoImageView.layer.shadowOffset = CGSize.init(width: 2, height: 10)
        self.logoImageView.layer.shadowRadius = 10
        
        self.loadingView = UIActivityIndicatorView.init(style: .gray)
        self.loadingView.isHidden = true
        self.loadingView.startAnimating()
		
		progressBg.backgroundColor = UIColor.init(hex: "f2faff")
		progressBg.frame = CGRect.init(x: 0, y: 0, width: 0, height: 85)
		self.containerView.addSubview(progressBg)
		self.containerView.sendSubviewToBack(progressBg)
		
    }
}
