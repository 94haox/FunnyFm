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
import SPLarkController

class PlayerDetailViewController: UIViewController,FMPlayerManagerDelegate {
    
    var episode: Episode! {
        didSet {
            configEpisode()
        }
    }
    
    var chaptersBtn: UIButton = UIButton.init(type: .custom)
    
    var chapterCountLB: UILabel = UILabel.init()
    
    var backBtn: UIButton!
    
    var titleLB: UILabel!
    
    var subTitle: UILabel!
	
	var swipeAniView: AnimationView!
	
	var playToolbar : PlayDetailToolBar!
    
    var rewindBtn: UIButton!
    
    var forwardBtn: UIButton!
	
	var noteBtn: UIButton!
	
	var functionsBtn: UIButton!
    
    var infoImageView: UIImageView!
	
	var noteImageView: UIImageView!
    
    var infoScrollView: UIScrollView!
    
    var coverBackView: UIView!
    
    var coverImageView: UIImageView!
    
    var progressLine: ChapterProgressView!
    
    var playBtn : UIButton!
    
    var viewModel: UserViewModel = UserViewModel()
	
	var startPoint: CGPoint!
	
    var timer: Timer?
	
	var hud: ProgressHUD!
	
	var isImpact = false
    
    var chapters: [Chapter] = [Chapter]()
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dw_addSubviews()
        self.dw_addConstraints()
        self.sh_interactivePopDisabled = true
		FMPlayerManager.shared.playerDelegate = self
        self.configEpisode()
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
	
	
	func playerStatusDidFailure() {
		SwiftNotice.showText("音频获取失败，请稍候重试")
        self.playBtn.isHidden = false
		self.playBtn.isSelected = false
		FMToolBar.shared.playBtn.isSelected = false
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
		}else if scrollView.contentOffset.x > 60{
            self.noteImageView.image = UIImage.init(named: "note_sel")?.tintImage
            self.noteImageView.tintColor = R.color.mainRed()
            self.noteImageView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 30, height: 30))
                make.left.equalTo(self.view.snp.right).offset(-60)
            }
			if !self.isImpact {
				self.isImpact = true
				let generator = UIImpactFeedbackGenerator.init(style: .heavy)
				generator.impactOccurred()
			}
		} else{
			self.isImpact = false;
            self.infoImageView.image = UIImage.init(named: "episode_info_nor")?.tintImage
            self.infoImageView.tintColor = R.color.mainRed()
            self.infoImageView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 50, height: 50))
                make.right.equalTo(self.infoScrollView.snp.left)
            }
			
			self.noteImageView.image = UIImage.init(named: "note_nor")
            self.noteImageView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width:30, height: 30))
				make.left.equalTo(self.view.snp.right).offset(-scrollView.contentOffset.x)
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
		
		if scrollView.contentOffset.x > 60{
			let listVC = NoteListViewController.init()
			listVC.episode = self.episode
            self.navigationController?.dw_presentAsStork(controller: listVC, heigth: kScreenHeight*0.4, delegate: self)
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
    
    func configEpisode() {
        guard self.isViewLoaded else {
            return
        }
        
        if let currentEpisode = FMToolBar.shared.currentEpisode, currentEpisode.trackUrl != episode.trackUrl {
            FMToolBar.shared.setUpChapter(episode)
        }
        
        self.titleLB.text = self.episode.title.trim()
        self.progressLine.allDot.text = "-" + FunnyFm.formatIntervalToMM(NSInteger(self.episode.duration))
        self.coverImageView.loadImage(url: (self.episode?.coverUrl)!, placeholder: nil) { [weak self] (image) in
            self?.coverBackView.addShadow(ofColor: image.mostColor(), radius: 10, offset: CGSize.zero, opacity: 0.7)
        }
        
        let podcast = DatabaseManager.getPodcast(feedUrl: self.episode.podcastUrl)
        if podcast.isSome {
            self.subTitle.text = podcast!.trackName
        }

        
        FMPlayerManager.shared.getChapters { (chapters) in
            guard let _ = chapters else {
                return
            }
            DispatchQueue.main.async {
                self.chaptersBtn.isHidden = chapters!.count < 1
                self.chapterCountLB.isHidden = chapters!.count < 1
                self.chapterCountLB.text = "\(chapters!.count)"
            }
            self.chapters = chapters!.map({ (avchapter) -> Chapter in
                return Chapter(title: avchapter.title, id: avchapter.identifier, time: avchapter.time)
            })
        }
    }
    
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
	
	@objc func editNote(){
		let noteVC = NoteEditViewController.init()
		noteVC.episode = self.episode
		self.navigationController?.present(noteVC, animated: true, completion: nil)
	}
	
	@objc func showFunctions() {
		// TODO: iOS 播放详情页面添加全功能下拉页面
	}
    
    @objc func showChapters() {
        let chapterListVC = ChapterListViewController()
        chapterListVC.chapters = self.chapters
        chapterListVC.skipClourse = { time in
            FMPlayerManager.shared.seekToTime(time.seconds)
        }
        self.present(chapterListVC, animated: true, completion: nil)
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
        guard let pod = DatabaseManager.getPodcast(feedUrl: episode.podcastUrl) else {
            return
        }
		let detailVC =  PodDetailViewController.init(pod: pod)
        if ClientConfig.shared.isIPad {
            let splitVC = AppDelegate.current.window.rootViewController as! UISplitViewController
            let navi = splitVC.viewControllers[1] as! UINavigationController
            self.navigationController?.dismiss(animated: true, completion: {
                navi.pushViewController(detailVC, animated: true)
            })
            return
        }
		let navi = AppDelegate.current.window.rootViewController as! UINavigationController
		self.navigationController?.dismiss(animated: true, completion: {
			navi.pushViewController(detailVC, animated: true)
		})
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
	
	func didTapSttBtn() {
        guard VipManager.shared.isVip else {
            alertVip()
            return
        }
		let speech = SpeechViewController.init()
		speech.episode = self.episode
		if self.playBtn.isSelected {
			self.tapPlayBtnAction(btn: self.playBtn)
		}
		self.dw_presentAsStork(controller: speech, heigth: kScreenHeight*0.6, delegate: self)
	}
	
	func didTapSleepBtn() {
		let alertController = UIAlertController.init(title: "定时关闭".localized, message: nil, preferredStyle: .actionSheet)
		let squaterAction = UIAlertAction.init(title: "15分钟后".localized, style: .default) { (action) in
			FMPlayerManager.shared.startSleep(seconds: 15*60)
		}
		let halfAction = UIAlertAction.init(title: "30分钟后".localized, style: .default){ (action) in
			FMPlayerManager.shared.startSleep(seconds: 30 * 60)
		}
		let hourAction = UIAlertAction.init(title: "一个小时后".localized, style: .default){ (action) in
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
            make.top.equalTo(self.view.snp_topMargin).offset(32.auto())
            make.width.equalToSuperview().offset(-30.auto())
        })
        
        self.subTitle.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLB.snp.bottom).offset(2.5)
        })
        
        self.backBtn.snp.makeConstraints({ (make) in
            if ClientConfig.shared.isIPad {
                make.left.equalToSuperview().offset(18.auto())
                make.centerY.equalTo(self.titleLB)
            }else{
                make.top.equalTo(self.playToolbar.snp_bottom).offset(8.auto())
                make.centerX.equalToSuperview()
            }
            make.size.equalTo(CGSize.init(width: 30.auto(), height: 30.auto()))
        })
        
        self.infoScrollView.snp.makeConstraints { (make) in
            make.centerX.width.equalToSuperview()
            make.centerY.equalTo(self.coverBackView)
            make.height.equalTo(self.coverBackView).offset(30.auto())
        }
        
        self.infoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 50.auto(), height: 50.auto()))
            make.right.equalTo(self.infoScrollView.snp.left)
        }
		
		self.noteImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
			make.size.equalTo(CGSize.init(width: 25, height: 25))
            make.left.equalTo(self.view.snp.right)
        }
        
        self.coverBackView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.subTitle.snp.bottom).offset(50.auto())
            make.size.equalTo(CGSize.init(width: 260.auto(), height: 260.auto()))
        })
		
		self.coverImageView.snp.makeConstraints({ (make) in
			make.edges.equalTo(self.coverBackView)
		})
		
        self.progressLine.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            if ClientConfig.shared.isIPad {
                make.width.equalToSuperview().multipliedBy(0.5)
            }else{
                make.width.equalToSuperview().offset(-48.auto())
            }
            make.height.equalTo(20.auto())
            make.top.equalTo(self.infoScrollView.snp.bottom).offset(27.auto())
        })
        
        self.playBtn.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.progressLine.snp.bottom).offset(100.auto())
            make.size.equalTo(CGSize.init(width: 60.auto(), height: 60.auto()))
        })
        
        self.rewindBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.playBtn)
            make.right.equalTo(self.playBtn.snp.left).offset(-50)
            make.size.equalTo(CGSize.init(width: 30.auto(), height: 30.auto()))
        })
        
        self.forwardBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.playBtn)
            make.left.equalTo(self.playBtn.snp.right).offset(50.auto())
            make.size.equalTo(CGSize.init(width: 30.auto(), height: 30.auto()))
        })
		
		self.playToolbar.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-40.auto())
			make.centerX.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalTo(48.auto())
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
			make.bottom.equalTo(self.progressLine.snp.top).offset(-20.auto())
			make.size.equalTo(CGSize.init(width: 60, height: 30.auto()))
		}
		
		self.noteBtn.snp.makeConstraints { (make) in
			make.right.equalTo(self.progressLine).offset(-10)
			make.top.equalTo(self.progressLine.snp.bottom).offset(24)
			make.size.equalTo(CGSize.init(width: 25, height: 25))
		}
		
		self.functionsBtn.snp.makeConstraints { (make) in
			make.left.equalTo(self.progressLine).offset(10)
			make.size.centerY.equalTo(self.noteBtn)
		}
        
        self.chaptersBtn.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(self.noteBtn)
			make.centerX.equalToSuperview()
        }
        
        self.chapterCountLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.chaptersBtn.snp_right).offset(4)
            make.centerY.equalTo(self.chaptersBtn)
        }
        
    }
    
    func dw_addSubviews(){
        
        self.view.backgroundColor = R.color.ffWhite()
        
        self.backBtn = UIButton.init(type: .custom)
        self.backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.backBtn.setImage(UIImage.init(named: "dismiss"), for: .normal)
        self.view.addSubview(self.backBtn)
        
        self.titleLB = UILabel.init(text: "")
        self.titleLB.textColor = CommonColor.title.color
        self.titleLB.font = p_bfont(fontsize6)
        self.titleLB.numberOfLines = 2;
        self.titleLB.textAlignment = .center
        self.view.addSubview(self.titleLB)
        self.subTitle = UILabel.init(text: self.episode.author)
        self.subTitle.isUserInteractionEnabled = true
        self.subTitle.font = pfont(fontsize2)
        self.view.addSubview(self.subTitle)
        self.subTitle.addGestureRecognizer(self.tapGes)
        
        self.infoScrollView = UIScrollView.init(frame: CGRect.zero)
        self.infoScrollView.showsHorizontalScrollIndicator = false;
        self.infoScrollView.alwaysBounceHorizontal = true;
        self.infoScrollView.layer.masksToBounds = false;
        self.infoScrollView.delegate = self;
        self.view.addSubview(self.infoScrollView)
		
        
        self.infoImageView = UIImageView.init(image: UIImage.init(named: "episode_info_nor"))
		self.noteImageView = UIImageView.init(image: UIImage.init(named: "note_nor"))
        self.infoScrollView.addSubview(self.infoImageView);
		self.infoScrollView.addSubview(self.noteImageView);
        
        self.coverBackView = UIView.init()
        self.coverBackView.cornerRadius = 15.auto()
        self.coverBackView.contentMode = .scaleAspectFit
        self.infoScrollView.addSubview(self.coverBackView)
        
		self.coverImageView = UIImageView.init()
        self.coverImageView.isUserInteractionEnabled = true
		
		
		self.coverImageView.cornerRadius = 15.auto()
		self.coverBackView.addSubview(self.coverImageView)
		
		self.playToolbar = PlayDetailToolBar.init(episode: self.episode)
//		self.playToolbar.layer.cornerRadius = 24.auto()
		self.playToolbar.delegate = self
		self.playToolbar.addShadow(ofColor: CommonColor.content.color, radius: 15, offset: CGSize.zero, opacity: 0.6)
		self.view.addSubview(self.playToolbar)
        
        self.progressLine = ChapterProgressView()
        self.progressLine.cycleW = 20.auto()
        self.progressLine.fontSize = fontsize0
		self.progressLine.delegate = self;
        self.view.addSubview(self.progressLine)
        
        self.playBtn = UIButton.init(type: .custom)
        let config = UIImage.SymbolConfiguration.init(pointSize: 350.auto(), weight: .medium)
        self.playBtn.setImage(UIImage.init(systemName: "play.circle.fill", withConfiguration: config)?.tintImage, for: .normal)
        self.playBtn.setImage(UIImage.init(systemName: "pause.circle.fill", withConfiguration: config)?.tintImage, for: .selected)
        self.playBtn.tintColor = R.color.mainRed()
        self.playBtn.isSelected = FMPlayerManager.shared.isPlay
        self.playBtn.addTarget(self, action: #selector(tapPlayBtnAction(btn:)), for: .touchUpInside)
        self.view.addSubview(self.playBtn)
        
        self.rewindBtn = UIButton.init(type: .custom)
        self.rewindBtn.setImage(UIImage.init(named: "rewind")!.tintImage, for: .normal)
        self.rewindBtn.tintColor = R.color.mainRed()
        self.rewindBtn.addTarget(self, action: #selector(rewindAction), for: .touchUpInside)
        self.view.addSubview(self.rewindBtn)
        
        self.forwardBtn = UIButton.init(type: .custom)
        self.forwardBtn.setImage(UIImage.init(named: "forward")!.tintImage, for: .normal)
        self.forwardBtn.tintColor = R.color.mainRed()
        self.forwardBtn.addTarget(self, action: #selector(forwardAction), for: .touchUpInside)
        self.view.addSubview(self.forwardBtn)
        
        self.swipeAniView = AnimationView.init(name: "swip_guid")
		self.swipeAniView.loopMode = .loop
		self.infoScrollView.addSubview(self.swipeAniView)
		
		self.hud = ProgressHUD.init(frame: CGRect.zero)
		self.view.addSubview(self.hud)
		
		self.noteBtn = UIButton.init(type: .custom)
        self.noteBtn.setImageForAllStates(UIImage.init(named: "filter-note-sel")!.tintImage)
        self.noteBtn.tintColor = R.color.mainRed()
		self.noteBtn.addTarget(self, action: #selector(editNote), for: .touchUpInside)
		self.view.addSubview(self.noteBtn)
		
		self.functionsBtn = UIButton.init(type: .custom)
		self.functionsBtn.tintColor = R.color.mainRed()
        self.functionsBtn.setImageForAllStates(UIImage.init(systemName: "slider.horizontal.3")!)
		self.functionsBtn.addTarget(self, action: #selector(showFunctions), for: .touchUpInside)
		self.view.addSubview(self.functionsBtn)
        
        self.chaptersBtn.setImageForAllStates(UIImage.init(named: "chapters")!.tintImage)
        self.chaptersBtn.addTarget(self, action: #selector(showChapters), for: .touchUpInside)
        self.chaptersBtn.tintColor = R.color.mainRed()
        self.chaptersBtn.isHidden = true
        self.view.addSubview(self.chaptersBtn)
        
        self.chapterCountLB.font = m_mfont(12.auto())
        self.chapterCountLB.textColor = R.color.mainRed()
        self.chapterCountLB.isHidden = true
        self.view.addSubview(self.chapterCountLB)


    }

    
}
