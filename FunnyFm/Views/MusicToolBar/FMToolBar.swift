//
//  FmToolBar.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher
import MediaPlayer
import RxSwift
import pop



class FMToolBar: UIView , FMPlayerManagerDelegate{

    static let shared = FMToolBar(frame: CGRect.init(x: 18, y: kScreenHeight-100-10, width: kScreenWidth-36, height: 80))
	
	var isPlaying: Bool = false
	
    var currentChapter: Chapter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.init(width: 2, height: 10)
        self.layer.shadowRadius = 10
        self.addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    lazy var playBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "Play"), for: .normal)
        btn.setImage(UIImage.init(named: "pause"), for: .selected)
        btn.backgroundColor = .white
        btn.cornerRadius = 15
        btn.isHidden = true
        btn.addTarget(self, action: #selector(didTapPlayBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var rewindBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "rewind"), for: .normal)
        return btn
    }()
    
    lazy var forwardBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "forward"), for: .normal)
        return btn
    }()
    
    lazy var authorLB : UILabel = {
        let lb = UILabel.init()
        lb.font = pfont(10)
        lb.textColor = CommonColor.content.color
        return lb
    }()
    
    lazy var titleLB : UILabel = {
        let lb = UILabel.init()
        lb.font = p_bfont(12)
        lb.textColor = CommonColor.title.color
        return lb
    }()
    
    lazy var logoImageView : UIImageView = {
        let imageview = UIImageView.init()
        imageview.layer.cornerRadius = 5;
        imageview.layer.shadowOpacity = 0.5
        imageview.layer.shadowOffset = CGSize.init(width: 2, height: 10)
        imageview.layer.shadowRadius = 10
        return imageview
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView.init(style: .gray)
        loading.startAnimating()
        return loading
    }()
    
    lazy var progressLine: UIView = {
        let view = UIView.init()
        view.cornerRadius = 2
        view.layer.masksToBounds = false
        return view
    }()

}


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
            if (self.isPlaying || !FMPlayerManager.shared.isFirst){
                self.playBtn.isSelected = true
                FMPlayerManager.shared.play()
            }
		}
    }
	
	func playerDidPlay() {
		self.isPlaying = true
	}
	
	func playerDidPause() {
//		self.isPlaying = false
	}
    
    func managerDidChangeProgress(progess: Double) {
        self.changeProgress(progess)
    }

}


extension FMToolBar{
    
    
    func configToolBarAtHome(_ chapter : Chapter) {
        self.config(chapter)
        let resource = ImageResource.init(downloadURL: URL.init(string: chapter.pod_cover_url)!)
        self.logoImageView.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil) { [unowned self] (downImage, error, type, url) in
            if(downImage != nil){
                self.configShadowColor()
            }
        }
    }
    
    func configToolBar(_ chapter : Chapter) {
        self.config(chapter)
        let resource = ImageResource.init(downloadURL: URL.init(string: chapter.cover_url_high)!)
        self.logoImageView.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil) { [unowned self] (downImage, error, type, url) in
            if(downImage != nil){
                self.configShadowColor()
            }
        }
    }
    
    func config(_ chapter: Chapter){
        
        if self.currentChapter.isNone {
           self.currentChapter = chapter
        }else{
            if self.currentChapter?.trackId == chapter.trackId  && self.isPlaying{
                SwiftNotice.noticeOnStatusBar("正在播放", autoClear: true, autoClearTime: 2)
                return
            }
            DatabaseManager.add(history: ListenHistoryModel.init(with: chapter))
            self.currentChapter = chapter
        }
        
        self.titleLB.text = chapter.title
        self.authorLB.text = chapter.pod_name
        self.setUpChapter(chapter)
    }
    
    func configShadowColor() {
        let color = self.logoImageView.image!.mostColor()
        self.logoImageView.layer.shadowColor = color!.cgColor
        self.progressLine.backgroundColor = color
        
    }
    
    func setUpChapter(_ chapter: Chapter){
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
    
    func changeProgress(_ progress:Double){

        self.progressLine.snp.updateConstraints { (make) in
            make.width.equalTo(Double.init((kScreenWidth-36-36)) * progress)
        }
        
        self.layoutIfNeeded()
    }
}


extension FMToolBar {
    
    func addConstraints() {
        
        self.backgroundColor = .white
        self.addSubview(self.logoImageView)
        self.addSubview(self.titleLB)
        self.addSubview(self.authorLB)
        self.addSubview(self.playBtn)
        self.addSubview(self.loadingView)
        self.addSubview(self.progressLine)
        
        self.logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.size.equalTo(CGSize.init(width: 45, height: 45))
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
            make.left.equalTo(self.logoImageView)
            make.height.equalTo(2)
            make.width.equalTo(0)
            make.bottom.equalToSuperview().offset(-2)
        }
        
//        self.rewindBtn.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.playBtn)
//            make.size.equalTo(CGSize.init(width: 30, height: 30))
//            make.right.equalTo(self.playBtn.snp.left).offset(-5)
//        }
//
//        self.forwardBtn.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.playBtn)
//            make.size.equalTo(CGSize.init(width: 30, height: 30))
//            make.left.equalTo(self.playBtn.snp.right)
//        }
		
        
        
        
    }
}
