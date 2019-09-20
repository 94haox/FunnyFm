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



class FMToolBar: UIView , FMPlayerManagerDelegate{

    static let shared = FMToolBar(frame: CGRect.init(x: 18, y: kScreenHeight-100-10, width: kScreenWidth-36, height: 80))
	
	var isPlaying: Bool = false
	
    var isShrink: Bool = false
    
    var currentEpisode: Episode?
    
    var containerView: UIView!
    
    var playBtn : UIButton!
    
    var authorLB : UILabel!
    
    var titleLB : UILabel!
    
    var logoImageView : UIImageView!
    
    var loadingView: UIActivityIndicatorView!
    
    var progressLine: ChapterProgressView!
	
	var progressLayer: CAShapeLayer!
	
	var progressBackView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
        self.addConstraints()
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
//		nav?.present(presentNavi, animated: true, completion: nil)
		nav?.presentAsStork(presentNavi)
	}
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !FMPlayerManager.shared.isCanPlay || self.isShrink {
            return
        }
        self.toPlayDetailView()
    }
}




// MARK: FMPlayerManagerDelegate
extension FMToolBar {
    
    @objc func didTapPlayBtnAction(btn:UIButton){
        btn.isSelected = !self.playBtn.isSelected
        if btn.isSelected {
            FMPlayerManager.shared.play()
        }else{
            FMPlayerManager.shared.pause()
			self.isPlaying = false
        }
    }
	
    
    func playerStatusDidChanged(isCanPlay: Bool) {
        self.loadingView.isHidden = isCanPlay
        self.playBtn.isHidden = !isCanPlay
		if isCanPlay{
			self.playBtn.isSelected = true
			FMPlayerManager.shared.play()
			self.progressLine.changeProgress(progress: 0, current: "00:00:00", total: FunnyFm.formatIntervalToMM(NSInteger(FMPlayerManager.shared.totalTime)))
		}
    }
	
	func playerDidPlay() {
		self.isPlaying = true
        if self.isShrink {
            PopManager.addRotationAnimation(self.logoImageView!.layer)
        }
	}
	
	func playerDidPause() {
//		self.isPlaying = false
        PopManager.removeRotationAnimation(self.logoImageView!.layer)
	}
    
    func managerDidChangeProgress(progess: Double, currentTime: Double, totalTime: Double) {
        self.progressLine.changeProgress(progress: progess, current: FunnyFm.formatIntervalToMM(NSInteger(currentTime)), total: FunnyFm.formatIntervalToMM(NSInteger(totalTime)))
		if let anim = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd){
			anim.fromValue = self.progressLayer.strokeEnd
			anim.toValue = progess
			anim.duration = 0.2
			anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
			self.progressLayer.pop_add(anim, forKey: "image_rotaion")
		}
    }
}


extension FMToolBar{
    
    
    func configToolBarAtHome(_ chapter : Episode) {
        self.config(chapter, url: chapter.coverUrl)
    }
    
    func configToolBar(_ episode : Episode) {
        self.config(episode,url: episode.coverUrl)
    }
    
	func config(_ chapter: Episode, url: String){
        self.isHidden = false
        if self.currentEpisode.isNone {
           self.currentEpisode = chapter
        }else{
            if self.currentEpisode?.title == chapter.title  && self.isPlaying{
                SwiftNotice.noticeOnStatusBar("正在播放", autoClear: true, autoClearTime: 2)
                return
            }
            DatabaseManager.add(history: chapter)
            self.currentEpisode = chapter
        }
		if(self.progressLayer.isSome) {
			self.progressLayer.pop_removeAllAnimations()
		}
        self.titleLB.text = chapter.title
        self.authorLB.text = chapter.author
        self.setUpChapter(chapter)
		self.logoImageView.loadImage(url: (self.currentEpisode?.coverUrl)!, placeholder: nil) {[unowned self] (image) in
			self.configShadowColor()
		}
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
        let anim = CABasicAnimation.init(keyPath: "transform.rotation.x")
        anim.toValue = NSNumber.init(value: Double.pi*3)
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim.duration = 0.2
        anim.isCumulative = true
        self.layer.add(anim, forKey: "rotationX")
    }
    
}


extension FMToolBar {
    
    
    
    func shrink(){
        self.containerView.isHidden = true
		self.progressBackView.isHidden = true
        let animationTime = 0.3
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius){
            anim.fromValue = NSNumber.init(value: 15)
            anim.toValue = NSNumber.init(value: Double(self.logoImageView.frame.size.width/2.0))
            anim.duration = animationTime
            self.layer.pop_add(anim, forKey: "self_radius")
        }
        
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius){
            anim.fromValue = NSNumber.init(value: 5)
            anim.toValue = NSNumber.init(value: Double(self.logoImageView.frame.size.width/2.0))
            anim.duration = animationTime
            self.logoImageView.layer.masksToBounds = true
            self.logoImageView.layer.pop_add(anim, forKey: "radius")
        }

        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY) {
            anim.toValue = NSValue.init(cgPoint: CGPoint.init(x: 0.8, y: 0.8))
            anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
            anim.duration = animationTime
            self.playBtn.layer.pop_add(anim, forKey: "scale")
        }
        
        UIView.animate(withDuration: animationTime, animations: {
            self.frame = CGRect.init(x: kScreenWidth-50-18, y: kScreenHeight-110+15, width: 50, height: 50)
            self.logoImageView.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 45, height: 45))
            }
            
            self.playBtn.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 30, height: 30))
            }
        }) { (isComplete) in
            if self.isPlaying {
                PopManager.addRotationAnimation(self.logoImageView!.layer)
            }
            self.isShrink = true
        }
    }
    
    func explain() {
		self.progressBackView.isHidden = false
        PopManager.removeRotationAnimation(self.logoImageView!.layer)
        let animationTime = 0.3
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius){
            anim.toValue = NSNumber.init(value: 15)
            anim.fromValue = NSNumber.init(value: Double(self.frame.size.width/2.0))
            anim.duration = animationTime
            self.layer.pop_add(anim, forKey: "reset_self_radius")
        }
        
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius){
            anim.toValue = NSNumber.init(value: 5)
            anim.fromValue = NSNumber.init(value: Double(self.logoImageView.frame.size.width/2.0))
            anim.duration = animationTime
            self.logoImageView.layer.masksToBounds = true
            self.logoImageView.layer.pop_add(anim, forKey: "reset_radius")
        }
        
        
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY) {
            anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 0.8, y: 0.8))
            anim.toValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
            anim.duration = animationTime
            self.playBtn.layer.pop_add(anim, forKey: "reset_scale")
        }
        
    
        UIView.animate(withDuration: animationTime, animations: {
            self.frame = CGRect.init(x: 18, y: kScreenHeight-100-10, width: kScreenWidth-36, height: 80)
            self.logoImageView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(16)
                make.size.equalTo(CGSize.init(width: 45, height: 45))
            }
            
            self.playBtn.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 30, height: 30))
                make.right.equalToSuperview().offset(-10)
            }
        }) { (isComplete) in
            self.containerView.isHidden = false
            self.isShrink = false
        }
        
    }
    
}


extension FMToolBar {
    
    func addConstraints() {
        self.backgroundColor = .white
        self.cornerRadius = 15.0
		
		
		
        self.addShadow(ofColor: UIColor.lightGray, radius: 10, offset: CGSize.init(width: 2, height: 10), opacity: 0.5)
        self.addSubview(self.containerView)
//		self.containerView.addSubview(self.progressBg);
        self.addSubview(self.logoImageView)
        self.containerView.addSubview(self.titleLB)
        self.containerView.addSubview(self.authorLB)
        self.addSubview(self.playBtn)
        self.addSubview(self.loadingView)
        self.containerView.addSubview(self.progressLine)
		
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView).offset(5)
            make.left.equalTo(self.logoImageView.snp.right).offset(16)
            make.width.equalTo(AdaptScale(200))
        }
        
        self.authorLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLB)
            make.bottom.equalTo(self.logoImageView).offset(-5)
        }
        
        self.logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize.init(width: 45, height: 45))
        }
        
        self.loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(self.playBtn)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        self.playBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.right.equalToSuperview().offset(-10)
        }
        
        self.progressLine.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-10)
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
		
		self.progressBackView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.logoImageView)
		}
		
        
    }
	
    func setUpUI() {
        self.containerView = UIView()
		self.containerView.layer.masksToBounds = true
		
		self.playBtn = UIButton.init(type: .custom)
        self.playBtn.setImage(UIImage.init(named: "play-red"), for: .normal)
        self.playBtn.setImage(UIImage.init(named: "pause-red"), for: .selected)
        self.playBtn.backgroundColor = .white
        self.playBtn.cornerRadius = 15
        self.playBtn.isHidden = true
        self.playBtn.addTarget(self, action: #selector(didTapPlayBtnAction(btn:)), for: .touchUpInside)
        
        self.authorLB = UILabel.init()
        self.authorLB.font = pfont(10)
        self.authorLB.textColor = CommonColor.content.color
        
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
        
        self.progressLine = ChapterProgressView.init(frame: CGRect.zero)
        self.progressLine.isHidden = true
		
		self.progressLayer = CAShapeLayer.init()
//		let bezier = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 32, height: 32))
		let bezier = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 45, height: 45), cornerRadius: 5)
		self.progressLayer.path = bezier.cgPath
		self.progressLayer.fillColor = UIColor.white.cgColor;
		self.progressLayer.strokeColor = CommonColor.mainRed.color.cgColor;
		self.progressLayer.strokeStart = 0
		self.progressLayer.strokeEnd = 0
		self.progressLayer.cornerRadius = 5
		self.progressLayer.lineWidth = 3
		self.progressLayer.lineCap = .square
		
		self.progressBackView = UIView.init()
		self.progressBackView.layer.addSublayer(self.progressLayer)
		self.addSubview(self.progressBackView)
		
    }
}
