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
import EFIconFont

class PlayerDetailViewController: UIViewController,FMPlayerManagerDelegate {
    
    var episode: Episode!
    
    var backBtn: UIButton!
    
    var titleLB: UILabel!
    
    var subTitle: UILabel!
    
//    var likeBtn: UIButton!
	
	var swipeAniView: AnimationView!
	
	var playToolbar : PlayDetailToolBar!
    
    var rewindBtn: UIButton!
    
    var forwardBtn: UIButton!
    
    var infoImageView: UIImageView!
    
    var infoScrollView: UIScrollView!
    
    var coverBackView: UIView!
    
    var coverImageView: UIImageView!
    
    var progressLine: ChapterProgressView!
    
    var playBtn : AnimationButton!
    
    var viewModel: UserViewModel = UserViewModel()
	
	var startPoint: CGPoint!
	
    var timer: Timer?
	
	var hud: ProgressHUD!
	
	var isImpact = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dw_addSubviews()
        self.dw_addConstraints()
        self.view.backgroundColor = CommonColor.background.color
        self.sh_interactivePopDisabled = true
		FMPlayerManager.shared.playerDelegate = self
		self.progressLine.allDot.text = "-" + FunnyFm.formatIntervalToMM(NSInteger(self.episode.duration))
		
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
		self.playToolbar.downBtn.isSelected = DatabaseManager.qureyDownload(title: self.episode.title).isSome
		FMToolBar.shared.isHidden = true
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		FMToolBar.shared.isHidden = false
	}
	
	
	lazy var tapGes: UITapGestureRecognizer = {
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(toPodDetail))
		return tap
	}()

}





// MARK: FMPlayerManagerDelegate
extension PlayerDetailViewController {
    
    func playerStatusDidChanged(isCanPlay: Bool) {
        self.playBtn!.isHidden = !isCanPlay
    }
    
    func playerDidPlay() {
        self.playBtn!.isSelected = true
		FMToolBar.shared.playBtn.isSelected = true
    }
    
    func playerDidPause() {
        self.playBtn!.isSelected = false
		FMToolBar.shared.playBtn.isSelected = false
    }
    
    func managerDidChangeProgress(progess: Double, currentTime: Double, totalTime: Double) {
        self.progressLine!.changeProgress(progress: progess, current: FunnyFm.formatIntervalToMM(NSInteger(currentTime)), total: FunnyFm.formatIntervalToMM(NSInteger(totalTime)-NSInteger(currentTime)))
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
            let episodeDetailVC = EpisodeInfoViewController()
            episodeDetailVC.episode = self.episode
			self.swipeAniView.removeSubviews()
            self.navigationController?.dw_presentAsStork(controller: episodeDetailVC, heigth: kScreenHeight * 0.85, delegate: self)
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
		ImpactManager.impact()
        FMPlayerManager.shared.seekAdditionSecond(-15)
    }
    
    @objc func forwardAction(){
		ImpactManager.impact()
        FMPlayerManager.shared.seekAdditionSecond(15)
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
	
    @objc func back(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
	
	@objc func toPodDetail(){
		let pod = DatabaseManager.getItunsPod(collectionId: episode.collectionId)
		let detailVC =  PodDetailViewController.init(pod: pod!)
		let navi = UIApplication.shared.keyWindow!.rootViewController as! UINavigationController
		navi.pushViewController(detailVC)
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
    
    func sleep(with time: String) {
        switch time {
        case "15分钟后".localized:
            break
        case "30分钟后".localized:
            break
        case "一个小时后".localized:
            break
        default:
            break
        }
    }
}

extension PlayerDetailViewController: PlayDetailToolBarDelegate {
	func didTapSleepBtn() {
		let alertController = UIAlertController.init(title: "定时关闭".localized, message: nil, preferredStyle: .actionSheet)
		let squaterAction = UIAlertAction.init(title: "15分钟后".localized, style: .default) { (action) in
			FMPlayerManager.shared.startSleep(seconds: 15*60)
		}
		let halfAction = UIAlertAction.init(title: "30分钟后".localized, style: .default){ (action) in
			FMPlayerManager.shared.startSleep(seconds: 30 * 60)
		}
		let hourAction = UIAlertAction.init(title: "1小时后".localized, style: .default){ (action) in
			FMPlayerManager.shared.startSleep(seconds: 60 * 60)
		}
		let endAction = UIAlertAction.init(title: "播放结束后".localized, style: .default){ (action) in}
		let cancelAction = UIAlertAction.init(title: "取消".localized, style: .cancel) { (action) in
			FMPlayerManager.shared.cancelSleep()
		}
		alertController.addAction(squaterAction)
		alertController.addAction(halfAction)
		alertController.addAction(hourAction)
		alertController.addAction(endAction)
		alertController.addAction(cancelAction)
		self.navigationController?.present(alertController, animated: true, completion: nil)
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
            make.top.equalTo(self.view.snp_topMargin).offset(32.adapt())
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
            make.height.equalTo(self.coverBackView).offset(30.adaptH())
        }
        
        self.infoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: AdaptScale(50), height: AdaptScale(50)))
            make.right.equalTo(self.infoScrollView.snp.left)
        }
        
        self.coverBackView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.subTitle.snp.bottom).offset(40.adaptH())
            make.size.equalTo(CGSize.init(width: 240.adaptH(), height: 240.adaptH()))
        })
		
		self.coverImageView.snp.makeConstraints({ (make) in
			make.edges.equalTo(self.coverBackView)
		})
		
		
        self.progressLine.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-48.adapt())
            make.height.equalTo(AdaptScale(20))
            make.top.equalTo(self.infoScrollView.snp.bottom).offset(27.adaptH())
        })
        
        self.playBtn.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.progressLine.snp.bottom).offset(50.adaptH())
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
		
		self.playToolbar.snp_makeConstraints { (make) in
			make.top.equalTo(self.playBtn.snp.bottom).offset(50.adaptH())
			make.centerX.equalToSuperview()
			make.width.equalToSuperview().offset(-40.adapt())
			make.height.equalTo(48.adapt())
		}
		
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
			make.bottom.equalTo(self.progressLine.snp.top).offset(-20.adaptH())
			make.size.equalTo(CGSize.init(width: 60, height: 30.adapt()))
		}
        
    }
    
    func dw_addSubviews(){
        self.backBtn = UIButton.init(type: .custom)
        self.backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.backBtn.setImage(UIImage.init(named: "dismiss"), for: .normal)
        self.view.addSubview(self.backBtn)
        
        self.titleLB = UILabel.init(text: self.episode.title.trim())
        self.titleLB.textColor = CommonColor.title.color
        self.titleLB.font = p_bfont(fontsize6)
        self.view.addSubview(self.titleLB)
        
		self.subTitle = UILabel.init(text: self.episode.author)
		self.subTitle.isUserInteractionEnabled = true
		let author = NSMutableAttributedString.init(string: self.episode.author)
		author.addAttributes([NSAttributedString.Key.foregroundColor : CommonColor.content.color, NSAttributedString.Key.font : pfont(fontsize2)], range: NSRange.init(location: 0, length: self.episode.author.length()))
		self.subTitle.attributedText = author + NSMutableAttributedString.init(string: " ") + NSMutableAttributedString.init(attributedString: EFIconFont.antDesign.rightCircle.attributedString(size: fontsize2, foregroundColor: CommonColor.content.color, backgroundColor: nil)!)
        self.view.addSubview(self.subTitle)
		self.subTitle.addGestureRecognizer(self.tapGes)
		
        
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
			self.coverBackView.addShadow(ofColor: image.mostColor(), radius: 20, offset: CGSize.zero, opacity: 0.8)
		}
		
		self.coverImageView.cornerRadius = 15.adapt()
		self.coverBackView.addSubview(self.coverImageView)
		
		self.playToolbar = PlayDetailToolBar.init(episode: self.episode)
		self.playToolbar.layer.cornerRadius = 24.adapt()
		self.playToolbar.delegate = self
		self.playToolbar.addShadow(ofColor: CommonColor.content.color, radius: 15, offset: CGSize.zero, opacity: 0.6)
		self.view.addSubview(self.playToolbar)
        
        self.progressLine = ChapterProgressView()
        self.progressLine.cycleW = 20.adapt()
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
        self.playBtn.addShadow(ofColor: CommonColor.mainRed.color, radius: 20.adapt(), offset: CGSize.zero, opacity: 0.8)
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
