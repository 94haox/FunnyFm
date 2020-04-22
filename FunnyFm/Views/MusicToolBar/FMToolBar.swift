//
//  FmToolBar.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import MediaPlayer
import pop

let toolbarH: CGFloat = ClientConfig.shared.isIPad ? 80.auto() : 55

let progressH = ClientConfig.shared.isIPad ? 10 : 4

let shinkRect = CGRect.init(x: 0, y: kScreenHeight - toolbarH, width: kScreenWidth, height: toolbarH+bottomSafeAreaHeight)

let explainRect = CGRect.init(x: 0, y: kScreenHeight - heightOfStackView - bottomSafeAreaHeight - toolbarH, width: kScreenWidth, height: toolbarH)

class FMToolBar: UIView , FMPlayerManagerDelegate{

    static let shared = ClientConfig.shared.isIPad ? FMToolBar(frame: CGRect.zero) : FMToolBar(frame: explainRect)

	var isPlaying: Bool = false
	
	var isStart: Bool = false
	
    var isShrink: Bool = false
	
	var bottomInset: CGFloat = 0 {
		didSet {
			FMToolBar.shared.explain()
		}
	}
    
    var currentEpisode: Episode? {
        didSet {
            configHandoff()
        }
    }
    
    var containerView: UIView!
    
    var playBtn : UIButton!
    
    var explainBtn = UIButton.init(type: .custom)
    
    var titleLB : UILabel!
    
    var logoImageView : UIImageView!
    
    var loadingView: UIActivityIndicatorView!
	
	var tapGes: UITapGestureRecognizer!
	
	let progressBg = UIView()
    
    var activity = NSUserActivity.init(activityType: "com.duke.www.FunnyFm")
    
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
        let playDetailVC = PlayerDetailViewController()
		playDetailVC.episode = self.currentEpisode
        let nav = AppDelegate.current.window.rootViewController
		let presentNavi = UINavigationController.init(rootViewController: playDetailVC)
		presentNavi.navigationBar.isHidden = true
		presentNavi.modalPresentationStyle = .fullScreen
		nav?.present(presentNavi, animated: true, completion: nil)
	}
    
	@objc func toPlayDetailVC(){
		if !FMPlayerManager.shared.isCanPlay{
            return
        }
        self.toPlayDetailView()
	}
}

// MARK: handoff

extension FMToolBar: NSUserActivityDelegate {
    
    func configHandoff() {
        guard let episode = currentEpisode, let data = episode.toData() else {
            return
        }
        let progress = DatabaseManager.qureyProgress(trackUrl: episode.trackUrl)
        activity.userInfo = ["episode": data, "track_url": episode.trackUrl, "progress": progress]
        activity.becomeCurrent()
        activity.delegate = self
    }
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        guard let userInfo = activity.userInfo else {
            return
        }
        let url = userInfo["track_url"] as? String
        if let trackurl = url, let progress = userInfo["progress"] as? Double {
            DatabaseManager.updateProgress(progress: progress, trackUrl: trackurl)
        }
        
        if let trackurl = url, let episode = DatabaseManager.getEpisode(trackUrl: trackurl) {
            self.configToolBar(episode)
            return
        }
        
        if let data = userInfo["episode"] as? Data {
            let episode = Episode.init(data: data)
            self.configToolBar(episode)
        }
    }
    
    func userActivityWillSave(_ userActivity: NSUserActivity) {
        self.configHandoff()
    }
    
    func userActivityWasContinued(_ userActivity: NSUserActivity) {
        
    }
    
    func userActivity(_ userActivity: NSUserActivity, didReceive inputStream: InputStream, outputStream: OutputStream) {
        
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
	
	func playerStatusDidFailure() {
		SwiftNotice.showText("音频获取失败，请稍候重试")
		self.loadingView.isHidden = true
        self.playBtn.isHidden = false
		self.playBtn.isSelected = false
		FMPlayerManager.shared.pause()
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
        self.configHandoff()
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
        self.progressBg.frame = CGRect.init(x: 0, y: Int(toolbarH) - progressH, width: 0, height: progressH)
        self.titleLB.text = chapter.title
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
        guard let _ = self.logoImageView.image else {
            return
        }
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
        guard !ClientConfig.shared.isIPad else {
            return
        }
		
        let animationTime = 0.3
	
        UIView.animate(withDuration: animationTime, animations: {
			self.frame = shinkRect
        }) { (isComplete) in
            self.isShrink = true
        }
    }
    
    func explain() {
        guard !ClientConfig.shared.isIPad else {
            return
        }

        let animationTime = 0.3
		
        UIView.animate(withDuration: animationTime, animations: {
			self.frame = explainRect
        }) { (isComplete) in
            self.containerView.isHidden = false
            self.isShrink = false
        }
        
    }
    
}


extension FMToolBar {
    
    func addConstraints(){
        if ClientConfig.shared.isIPad {
            self.addConstraintsForIPad()
        }else{
            self.addConstraintsForIphone()
        }
    }
    
    func addConstraintsForIPad() {
        self.backgroundColor = CommonColor.whiteBackgroud.color
        self.addShadow(ofColor: UIColor.lightGray, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 0.5)
        self.playBtn.tintColor = R.color.mainRed()
        self.addSubview(self.containerView)
        self.addSubview(self.logoImageView)
        self.containerView.addSubview(self.titleLB)
        self.addSubview(self.playBtn)
        self.addSubview(self.loadingView)
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.titleLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.logoImageView.snp.right).offset(32.auto())
            make.width.equalTo(400.auto())
            make.centerY.equalToSuperview()
        }
        
        self.logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32.auto())
            make.size.equalTo(CGSize.init(width: 50.auto(), height: 50.auto()))
        }
        
        self.loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(self.playBtn)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        self.playBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.logoImageView)
            make.size.equalTo(CGSize.init(width: 30.auto(), height: 30.auto()))
            make.right.equalToSuperview().offset(-50.auto())
        }
    }
    
    func addConstraintsForIphone() {
        self.titleLB.textColor = .white
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.logoImageView)
        self.containerView.addSubview(self.titleLB)
        self.containerView.addSubview(self.playBtn)
        self.containerView.addSubview(self.loadingView)
        self.containerView.addSubview(self.explainBtn)
        
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: .topLeft, cornerRadii: CGSize.init(width: 25, height: 25))
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.backgroundColor = R.color.mainRed()
		
        self.containerView.snp.makeConstraints { (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(toolbarH)
        }
        
        self.titleLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.logoImageView.snp.right).offset(16)
            make.width.equalTo(200.auto())
			make.centerY.equalToSuperview()
        }
        
        self.explainBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        
        self.logoImageView.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
            make.left.equalTo(self.explainBtn.snp.right).offset(12.auto())
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
		self.playBtn = UIButton.init(type: .custom)
        let config = UIImage.SymbolConfiguration.init(pointSize: 60, weight: .medium)
        self.playBtn.setImage(UIImage.init(systemName: "play.circle.fill", withConfiguration: config)?.tintImage, for: .normal)
        self.playBtn.setImage(UIImage.init(systemName: "pause.circle.fill", withConfiguration: config)?.tintImage, for: .selected)
        self.playBtn.tintColor = .white
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
        self.loadingView = UIActivityIndicatorView.init(style: .white)
        self.loadingView.isHidden = true
        self.loadingView.startAnimating()
		
        progressBg.backgroundColor = CommonColor.progress.color
        progressBg.frame = CGRect.init(x: 0, y: Int(toolbarH)-progressH, width: 0, height: progressH)
		self.containerView.addSubview(progressBg)
		self.containerView.sendSubviewToBack(progressBg)
        
        self.explainBtn.setImageForAllStates(UIImage.init(systemName: "chevron.up")!)
        self.explainBtn.addTarget(self, action: #selector(toPlayDetailVC), for: .touchUpInside)
        self.explainBtn.tintColor = .white
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle == .dark  || self.traitCollection.userInterfaceStyle == .light{
            self.configShadowColor()
            self.addShadow(ofColor: UIColor.lightGray, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 0.5)
        }else if self.traitCollection.userInterfaceStyle != .light {
            self.logoImageView.layer.shadowColor = UIColor.clear.cgColor
            self.cleanShadow()
        }
    }
}

