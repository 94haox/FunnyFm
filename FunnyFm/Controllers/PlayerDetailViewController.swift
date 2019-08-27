//
//  PlayerDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import pop
import Lottie
import MediaPlayer
import AVKit

class PlayerDetailViewController: BaseViewController,FMPlayerManagerDelegate {
    
    var episode: Episode!
    
    var backBtn: UIButton!
    
    var titleLB: UILabel!
    
    var subTitle: UILabel!
    
//    var likeBtn: UIButton!
	
	var airBtn: AVRoutePickerView!
	
	var likeAniView: AnimationView!
	
	var swipeAniView: AnimationView!
	
    var rateBtn: UIButton!
    
    var downBtn: UIButton!
    
    var rewindBtn: UIButton!
    
    var forwardBtn: UIButton!
    
    var sleepBtn: UIButton!
    
    var infoImageView: UIImageView!
    
    var infoScrollView: UIScrollView!
    
    var coverBackView: UIView!
    
    var coverImageView: UIImageView!
    
    var progressLine: ChapterProgressView!
    
    var playBtn : AnimationButton!
    
    var downProgressLayer: CAShapeLayer!
    
    var downBackView: UIView!
    
    var viewModel: UserViewModel = UserViewModel()
	
	var startPoint: CGPoint!
	
    var timer: Timer?
	
	var hud: ProgressHUD!
	
	var isImpact = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dw_addSubviews()
        self.dw_addConstraints()
        self.view.backgroundColor = .white
        self.sh_interactivePopDisabled = true
		FMPlayerManager.shared.playerDelegate = self
		
//        if self.chapter.isFavour {
//            self.likeAniView.play(fromProgress: 0.9, toProgress: 1) { (complete) in
//                self.likeBtn.isHidden = true;
//            }
//        }
		
		if DatabaseManager.qureyDownload(title: self.episode.title).isSome {
			self.downBtn.isSelected = true
		}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		if !UserDefaults.standard.bool(forKey: "isFristSwip") {
			self.swipeAniView.play()
			UserDefaults.standard.set(true, forKey: "isFristSwip")
		}else{
			self.swipeAniView.pause()
			self.swipeAniView.isHidden = true
		}
		
		FMToolBar.shared.isHidden = true
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		FMToolBar.shared.isHidden = false
	}

}





// MARK: FMPlayerManagerDelegate
extension PlayerDetailViewController {
    
    func playerStatusDidChanged(isCanPlay: Bool) {
        self.playBtn!.isHidden = !isCanPlay
    }
    
    func playerDidPlay() {
        self.playBtn!.isSelected = true
    }
    
    func playerDidPause() {
        self.playBtn!.isSelected = false
    }
    
    func managerDidChangeProgress(progess: Double, currentTime: Double, totalTime: Double) {
        self.progressLine!.changeProgress(progress: progess, current: FunnyFm.formatIntervalToMM(NSInteger(currentTime)), total: FunnyFm.formatIntervalToMM(NSInteger(totalTime)))
		
    }
    
}

// MARK: - DownloadManagerDelegate
extension PlayerDetailViewController: DownloadManagerDelegate {
	
	func downloadProgress(progress: Double) {
		if let anim = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd){
			anim.fromValue = self.downProgressLayer.strokeEnd
			anim.toValue = progress
			anim.duration = 0.2
			anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
			self.downProgressLayer.pop_add(anim, forKey: "image_rotaion")
		}
	}
	
	func didDownloadSuccess(fileUrl: String?) {
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
		self.episode!.download_filpath = (fileUrl?.components(separatedBy: "/").last)!
		DatabaseManager.add(download: self.episode!)
	}
	
	func didDownloadFailure() {
		SwiftNotice.showText("下载失败")
	}
	
}

// MARK: - UIScrollViewDelegate
extension PlayerDetailViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < -60 {
            self.infoImageView.image = UIImage.init(named: "episode_info_sel")
            self.infoImageView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 50, height: 50))
                make.right.equalTo(self.view.snp.left).offset(60)
            }
			if !self.isImpact {
				self.isImpact = true
				let generator = UIImpactFeedbackGenerator.init(style: .heavy)
				generator.impactOccurred()
			}
        }else{
			self.isImpact = false;
            self.infoImageView.image = UIImage.init(named: "episode_info_nor")
            self.infoImageView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 50, height: 50))
                make.right.equalTo(self.infoScrollView.snp.left)
            }
        }
    }
	
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.x < -60 {
            let episodeDetailVC = EpisodeDetailViewController()
            episodeDetailVC.episode = self.episode
			self.swipeAniView.removeSubviews()
            self.navigationController?.pushViewController(episodeDetailVC)
        }
    }
}

// MARK: - ChapterProgressDelegate
extension PlayerDetailViewController : ChapterProgressDelegate {
	
	func progressDidChange(progress: CGFloat) {
		if !FMPlayerManager.shared.isCanPlay {
			return
		}
		
		let time = FunnyFm.formatIntervalToMM(NSInteger(FMPlayerManager.shared.totalTime * Double(progress)))
		self.hud.show(title: time)
	}
	
	func progressDidEndDrag() {
		self.hud.hide()
	}
	
}

// MARK: actions
extension PlayerDetailViewController {
    
    @objc func tapPlayBtnAction(btn:UIButton){
        btn.isSelected = !self.playBtn!.isSelected
        if btn.isSelected {
            FMPlayerManager.shared.play()
        }else{
            FMPlayerManager.shared.pause()
        }
    }
    
    @objc func rewindAction(){
        FMPlayerManager.shared.seekAdditionSecond(-15)
    }
    
    @objc func forwardAction(){
        FMPlayerManager.shared.seekAdditionSecond(15)
    }
    
    @objc func downloadAction(){
		if self.downBtn.isSelected {
			SwiftNotice.showText("已下载")
			return;
		}
		DownloadManager.shared.delegate = self;
		DownloadManager.shared.beginDownload(self.episode)
    }
	
	@objc func likeAction(){
        
//        if !UserCenter.shared.isLogin {
//			self.navigationController?.pushViewController(NeLoginViewController.init())
//            return
//        }
//
//		if self.likeBtn.isHidden {
//			self.likeAniView.play(fromProgress: 1, toProgress: 0) {[unowned self] (isEnd) in
//				self.likeBtn.isHidden = false
//			}
//            self.viewModel.deleteFavour(self.episode.trackUrl)
//			return
//		}
//        self.viewModel.addFavour(self.episode.trackUrl)
//		self.likeBtn.isHidden = true
//		self.likeAniView.play()

	}
    
    @objc func setSleepTime(){
		
        let alertController = UIAlertController.init(title: "定时关闭", message: nil, preferredStyle: .actionSheet)
        let squaterAction = UIAlertAction.init(title: "15分钟后", style: .default) { (action) in
            FMPlayerManager.shared.startSleep(seconds: 15*60)
        }
        let halfAction = UIAlertAction.init(title: "30分钟后", style: .default){ (action) in
            FMPlayerManager.shared.startSleep(seconds: 30 * 60)
        }
        let hourAction = UIAlertAction.init(title: "1小时后", style: .default){ (action) in
            FMPlayerManager.shared.startSleep(seconds: 60 * 60)
        }
        let endAction = UIAlertAction.init(title: "播放结束后", style: .default){ (action) in}
		let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
			FMPlayerManager.shared.cancelSleep()
		}
        alertController.addAction(squaterAction)
        alertController.addAction(halfAction)
        alertController.addAction(hourAction)
        alertController.addAction(endAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
		
    }
    
    @objc func changeRateAction(btn: UIButton){
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
    
    @objc func back(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func sleep(with time: String) {
        switch time {
        case "15分钟后":
            break
        case "30分钟后":
            break
        case "一个小时后":
            break
        default:
            break
        }
    }
    
    func timerAction(){
        
    }
    
}

// MARK: - Touch
extension PlayerDetailViewController {
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.randomElement()
		let point = touch?.location(in: self.view)
		self.startPoint = point
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.randomElement()
		let point = touch?.location(in: self.view)
		if (point!.y - self.startPoint.y > 100) {
			self.back()
		}
		
	}
	
}

// MARK:  UI
extension PlayerDetailViewController {
    
    func dw_addConstraints(){
        
        self.titleLB.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp_topMargin).offset(16.adapt())
            make.width.equalTo(200)
        })
        
        self.subTitle.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLB.snp.bottom).offset(2.5)
        })
        
        self.backBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.titleLB)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(CGSize.init(width: AdaptScale(30), height: AdaptScale(30)))
        })
        
        self.infoScrollView.snp.makeConstraints { (make) in
            make.centerX.width.equalToSuperview()
            make.centerY.equalTo(self.coverBackView)
            make.height.equalTo(self.coverBackView).offset(AdaptScale(30))
        }
        
        self.infoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: AdaptScale(50), height: AdaptScale(50)))
            make.right.equalTo(self.infoScrollView.snp.left)
        }
        
        self.coverBackView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.subTitle.snp.bottom).offset(AdaptScale(57))
            make.size.equalTo(CGSize.init(width: AdaptScale(200), height: AdaptScale(200)))
        })
		
		self.coverImageView.snp.makeConstraints({ (make) in
			make.edges.equalTo(self.coverBackView)
		})
        
//        self.likeBtn.snp.makeConstraints({ (make) in
//            make.top.equalTo(self.subTitle.snp.bottom).offset(AdaptScale(77+57)+AdaptScale(244))
//            make.right.equalTo(self.view.snp.centerX).offset(-32)
//            make.size.equalTo(CGSize.init(width: 25, height: 25))
//        })
		
		self.airBtn.snp.makeConstraints({ (make) in
			make.top.equalTo(self.subTitle.snp.bottom).offset(AdaptScale(57)+AdaptScale(244))
			make.right.equalTo(self.view.snp.centerX).offset(-32)
			make.size.equalTo(CGSize.init(width: AdaptScale(25), height: AdaptScale(25)))
		})
		
        self.rateBtn.snp.makeConstraints({ (make) in
			make.centerY.equalTo(self.airBtn)
            make.left.equalTo(self.view.snp.centerX).offset(32)
            make.size.equalTo(CGSize.init(width: AdaptScale(30), height: AdaptScale(25)))
        })
        
        self.downBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.airBtn)
            make.left.equalTo(self.rateBtn!.snp.right).offset(AdaptScale(70))
            make.size.equalTo(CGSize.init(width: AdaptScale(25), height: AdaptScale(25)))
        })
        
        self.downBackView.snp.makeConstraints { (make) in
            make.center.equalTo(self.downBtn)
            make.size.equalTo(CGSize.init(width: AdaptScale(35), height: AdaptScale(35)))
        }
        
        self.sleepBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.airBtn)
            make.right.equalTo(self.airBtn.snp.left).offset(-74)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        })
        
        self.progressLine.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(AdaptScale(20))
            make.top.equalTo(self.downBtn.snp.bottom).offset(72.adapt())
        })
        
        self.playBtn.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-50.adapt())
            make.size.equalTo(CGSize.init(width: AdaptScale(60), height: AdaptScale(60)))
        })
        
        self.rewindBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.playBtn)
            make.right.equalTo(self.playBtn.snp.left).offset(-50)
            make.size.equalTo(CGSize.init(width: AdaptScale(30), height: AdaptScale(30)))
        })
        
        self.forwardBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.playBtn)
            make.left.equalTo(self.playBtn.snp.right).offset(50.adapt())
            make.size.equalTo(CGSize.init(width: 30.adapt(), height: 30.adapt()))
        })
		
//		self.likeAniView.snp.makeConstraints { (make) in
//			make.center.equalTo(self.likeBtn)
//			make.size.equalTo(self.likeBtn).multipliedBy(2)
//		}
		
		self.swipeAniView.snp.makeConstraints { (make) in
			make.center.equalTo(self.coverImageView)
			make.width.equalToSuperview()
			make.height.equalTo(self.coverImageView)
		}
		
		self.hud.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview();
			make.bottom.equalTo(self.progressLine.snp.top).offset(-20.adapt())
			make.size.equalTo(CGSize.init(width: 60, height: 30.adapt()))
		}
        
    }
    
    func dw_addSubviews(){
        self.backBtn = UIButton.init(type: .custom)
        self.backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.backBtn.setImage(UIImage.init(named: "dismiss"), for: .normal)
        self.view.addSubview(self.backBtn)
        
        self.titleLB = UILabel.init(text: self.episode.title)
        self.titleLB.textColor = CommonColor.title.color
        self.titleLB.font = p_bfont(fontsize6)
        self.view.addSubview(self.titleLB)
        
        self.subTitle = UILabel.init(text: self.episode.author)
        self.subTitle.textColor = CommonColor.content.color
        self.subTitle.font = pfont(fontsize0)
        self.view.addSubview(self.subTitle)
        
        self.infoScrollView = UIScrollView.init(frame: CGRect.zero)
        self.infoScrollView.showsHorizontalScrollIndicator = false;
        self.infoScrollView.alwaysBounceHorizontal = true;
        self.infoScrollView.layer.masksToBounds = false;
        self.infoScrollView.delegate = self;
        self.view.addSubview(self.infoScrollView)
        
        self.infoImageView = UIImageView.init(image: UIImage.init(named: "episode_info_nor"))
        self.infoScrollView.addSubview(self.infoImageView);
        
        self.coverBackView = UIView.init()
        self.coverBackView.cornerRadius = 15.adapt()
        self.infoScrollView.addSubview(self.coverBackView)
        
		self.coverImageView = UIImageView.init()
        self.coverImageView.isUserInteractionEnabled = true
		self.coverImageView.loadImage(url: (self.episode?.coverUrl)!, placeholder: nil) { [unowned self] (image) in
			self.coverBackView.addShadow(ofColor: image.mostColor(), radius: 20, offset: CGSize.init(width: 0, height: 0), opacity: 0.8)
		}
		
		self.coverImageView.cornerRadius = 15.adapt()
		self.coverBackView.addSubview(self.coverImageView)
		
//		self.likeAniView = AnimationView(name: "like_button")
//
//		let tap = UITapGestureRecognizer.init(target: self, action: #selector(likeAction))
//		self.likeAniView.addGestureRecognizer(tap)
//		self.view.addSubview(self.likeAniView)
//
//        self.likeBtn = UIButton.init(type: .custom)
//        self.likeBtn.setImage(UIImage.init(named: "favor-nor"), for: .normal)
//        self.likeBtn.setImage(UIImage.init(named: "favor-sel"), for: .selected)
//		self.likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
//        self.view.addSubview(self.likeBtn)
		
		self.airBtn = AVRoutePickerView.init(frame: CGRect.zero)
		self.airBtn.activeTintColor = CommonColor.mainRed.color
		self.airBtn.tintColor = CommonColor.title.color
		self.view.addSubview(self.airBtn)
		
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
        self.view.addSubview(self.downBackView)
        
        self.downBtn = UIButton.init(type: .custom)
        self.downBtn.setImage(UIImage.init(named: "download-black"), for: .normal)
		self.downBtn.setImage(UIImage.init(named: "download-red"), for: .selected)
        self.downBtn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        self.view.addSubview(self.downBtn)
        
        
        self.sleepBtn = UIButton.init(type: .custom)
        self.sleepBtn.imageView?.contentMode = .scaleAspectFit
        self.sleepBtn.setImage(UIImage.init(named: "timer-sleep"), for: .normal)
        self.sleepBtn.addTarget(self, action: #selector(setSleepTime), for: .touchUpInside)
        self.view.addSubview(self.sleepBtn)
        
        self.rateBtn = UIButton.init(type: .custom)
        self.rateBtn.setTitle("1x", for: .normal)
        self.rateBtn.titleLabel?.font = h_bfont(fontsize6)
        self.rateBtn.setTitleColor(CommonColor.title.color, for: .normal)
        self.rateBtn.addTarget(self, action: #selector(changeRateAction(btn:)), for: .touchUpInside)
        self.view.addSubview(self.rateBtn)
        
        self.progressLine = ChapterProgressView()
        self.progressLine.cycleW = 18.adapt()
        self.progressLine.fontSize = fontsize0
		self.progressLine.delegate = self;
        self.view.addSubview(self.progressLine)
        
        self.playBtn = AnimationButton.init(type: .custom)
        self.playBtn.setImage(UIImage.init(named: "play-red"), for: .normal)
        self.playBtn.setImage(UIImage.init(named: "play-high"), for: .highlighted)
        self.playBtn.setImage(UIImage.init(named: "pause-red"), for: .selected)
        self.playBtn.isSelected = FMPlayerManager.shared.isPlay
        self.playBtn.addTarget(self, action: #selector(tapPlayBtnAction(btn:)), for: .touchUpInside)
        self.playBtn.cornerRadius = 30.adapt()
        self.playBtn.addShadow(ofColor: CommonColor.mainRed.color, opacity: 0.8)
        self.view.addSubview(self.playBtn)
        
        self.rewindBtn = UIButton.init(type: .custom)
        self.rewindBtn.setImage(UIImage.init(named: "rewind"), for: .normal)
        self.rewindBtn.addTarget(self, action: #selector(rewindAction), for: .touchUpInside)
        self.view.addSubview(self.rewindBtn)
        
        self.forwardBtn = UIButton.init(type: .custom)
        self.forwardBtn.setImage(UIImage.init(named: "forward"), for: .normal)
        self.forwardBtn.addTarget(self, action: #selector(forwardAction), for: .touchUpInside)
        self.view.addSubview(self.forwardBtn)
        
        self.swipeAniView = AnimationView.init(name: "swip_guid")
		self.swipeAniView.loopMode = .loop
		self.infoScrollView.addSubview(self.swipeAniView)
		
		self.hud = ProgressHUD.init(frame: CGRect.zero)
		self.view.addSubview(self.hud)

    }

    
}
