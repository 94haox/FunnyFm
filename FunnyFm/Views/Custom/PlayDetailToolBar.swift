//
//  PlayDetailToolBar.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/29.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import pop
import Lottie
import MediaPlayer
import AVKit


@objc protocol PlayDetailToolBarDelegate {
	func didTapSleepBtn()
}

class PlayDetailToolBar: UIView {
	
	weak var delegate: PlayDetailToolBarDelegate?
	
	var episode: Episode!
	
	var airBtn: AVRoutePickerView!
	
	var likeAniView: AnimationView!
	
	var rateBtn: UIButton!
	
	var downBtn: UIButton!
	
	var sleepBtn: UIButton!
	
	var downProgressLayer: CAShapeLayer!
	
	var downBackView: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.dw_addSubviews()
	}
	
	init(episode: Episode) {
		super.init(frame: CGRect.zero)
		self.backgroundColor = UIColor.white
		self.episode = episode
		self.dw_addSubviews()
		self.dw_addConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}


// MARK: - Actions
extension PlayDetailToolBar {
	
	@objc func downloadAction(){
		ImpactManager.impact()
		if self.downBtn.isSelected {
			SwiftNotice.showText("已下载")
			return;
		}
		DownloadManager.shared.delegate = self;
		DownloadManager.shared.beginDownload(self.episode)
		if let anim = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd){
			anim.fromValue = self.downProgressLayer.strokeEnd
			anim.toValue = 0.1
			anim.duration = 0.2
			anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
			self.downProgressLayer.pop_add(anim, forKey: "image_rotaion")
		}
	}
	
	@objc func setSleepTime(){
		ImpactManager.impact()
		self.delegate?.didTapSleepBtn()
	}
	
	@objc func changeRateAction(btn: UIButton){
		ImpactManager.impact()
		var rate = 1.0;
		switch btn.titleLabel?.text {
		case "1x":
			btn.setTitle("1.5x", for: .normal)
			rate = 1.5
			break
		case "2x":
			btn.setTitle("1x", for: .normal)
			rate = 1
			break
		case "1.5x":
			btn.setTitle("2x", for: .normal)
			rate = 2
			break
		default:
			break
		}
		
		FMPlayerManager.shared.playRate = Float(rate)
		FMPlayerManager.shared.player?.rate = Float(rate)
		if !FMPlayerManager.shared.isPlay {
			FMPlayerManager.shared.player?.pause()
		}
	}
}

// MARK: - DownloadManagerDelegate
extension PlayDetailToolBar: DownloadManagerDelegate {
	func downloadProgress(progress: Double, sourceUrl: String) {
		guard sourceUrl == self.episode.trackUrl else {
			return
		}
		if let anim = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd){
			anim.fromValue = self.downProgressLayer.strokeEnd
			anim.toValue = progress
			anim.duration = 0.2
			anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
			self.downProgressLayer.pop_add(anim, forKey: "image_rotaion")
		}
	}
	
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String) {
		guard sourceUrl == self.episode.trackUrl else {
			return
		}
		
		if fileUrl.isNone{
			SwiftNotice.showText("下载失败")
			return
		}
		self.downBtn.isSelected = true
		self.downProgressLayer.isHidden = true
		SwiftNotice.showText("下载成功，您可以在个人中心-我的下载查看")
		if let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
			anim.toValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
			anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1.5, y: 1.5))
			anim.springBounciness = 20
			self.downBtn!.layer.pop_add(anim, forKey: "size")
		}
	}
	
	func didDownloadFailure(sourceUrl: String) {
		guard sourceUrl == self.episode.trackUrl else {
			return
		}
		self.downProgressLayer.removeAllAnimations()
		SwiftNotice.showText("下载失败")
	}
	
	
}


// MARK: - UI
extension PlayDetailToolBar {
	
	func dw_addConstraints(){
		self.airBtn.snp.makeConstraints({ (make) in
			make.centerY.equalTo(self)
			make.right.equalTo(self.snp.centerX).offset(-25.adapt())
			make.size.equalTo(CGSize.init(width: 25.adapt(), height: 25.adapt()))
		})
		
		self.rateBtn.snp.makeConstraints({ (make) in
			make.centerY.equalTo(self.airBtn)
			make.left.equalTo(self.snp.centerX).offset(25.adapt())
			make.size.equalTo(CGSize.init(width: 40.adapt(), height: 25.adapt()))
		})
		
		self.downBtn.snp.makeConstraints({ (make) in
			make.centerY.equalTo(self.airBtn)
			make.left.equalTo(self.rateBtn!.snp.right).offset(50.adapt())
			make.size.equalTo(CGSize.init(width: 25.adapt(), height: 25.adapt()))
		})
		
		self.downBackView.snp.makeConstraints { (make) in
			make.center.equalTo(self.downBtn)
			make.size.equalTo(CGSize.init(width: 35.adapt(), height: 35.adapt()))
		}
		
		self.sleepBtn.snp.makeConstraints({ (make) in
			make.centerY.equalTo(self.airBtn)
			make.right.equalTo(self.airBtn.snp.left).offset(-50.adapt())
			make.size.equalTo(CGSize.init(width: 25.adapt(), height: 25.adapt()))
		})
	}
	
	func dw_addSubviews(){
		
		self.airBtn = AVRoutePickerView.init(frame: CGRect.zero)
		self.airBtn.activeTintColor = CommonColor.mainRed.color
		self.airBtn.tintColor = CommonColor.title.color
		self.addSubview(self.airBtn)
		
		self.downProgressLayer = CAShapeLayer.init()
		let bezier = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 35, height: 35))
		self.downProgressLayer.path = bezier.cgPath
		self.downProgressLayer.fillColor = UIColor.white.cgColor;
		self.downProgressLayer.strokeColor = CommonColor.mainRed.color.cgColor;
		self.downProgressLayer.strokeStart = 0
		self.downProgressLayer.strokeEnd = 0
		self.downProgressLayer.cornerRadius = 3
		self.downProgressLayer.lineWidth = 3
		self.downProgressLayer.lineCap = .round
		
		self.downBackView = UIView.init()
		self.downBackView.layer.addSublayer(self.downProgressLayer)
		self.addSubview(self.downBackView)
		
		self.downBtn = UIButton.init(type: .custom)
		self.downBtn.setImage(UIImage.init(named: "download-black"), for: .normal)
		self.downBtn.setImage(UIImage.init(named: "download-red"), for: .selected)
		self.downBtn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
		self.addSubview(self.downBtn)
		
		
		self.sleepBtn = UIButton.init(type: .custom)
		self.sleepBtn.imageView?.contentMode = .scaleAspectFit
		self.sleepBtn.setImage(UIImage.init(named: "timer-sleep"), for: .normal)
		self.sleepBtn.addTarget(self, action: #selector(setSleepTime), for: .touchUpInside)
		self.addSubview(self.sleepBtn)
		
		self.rateBtn = UIButton.init(type: .custom)
		self.rateBtn.setTitle("1x", for: .normal)
		self.rateBtn.titleLabel?.sizeThatFits(CGSize.init(width: 40.adapt(), height: 25.adapt()))
		self.rateBtn.titleLabel?.font = h_bfont(fontsize6.adapt())
		self.rateBtn.setTitleColor(CommonColor.title.color, for: .normal)
		self.rateBtn.addTarget(self, action: #selector(changeRateAction(btn:)), for: .touchUpInside)
		self.addSubview(self.rateBtn)
	}
	
}
