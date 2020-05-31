//
//  FunctionsViewController.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/5/29.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import DNSPageView
import Panels

class FunctionsViewController: UIViewController, Panelable {
	
	var playToolbar: PlayDetailToolBar!
	
	var headerHeight: NSLayoutConstraint!
	
	var episode: Episode!
	
	var headerPanel: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		self.view.addBlurBackground()
		self.curveTopCorners()
		self.setUpPlayToolbar()
		self.setUpPageViews()
	}
	
}

extension FunctionsViewController: PlayDetailToolBarDelegate {
	
	func didTapSttBtn() {
		guard VipManager.shared.isVip else {
            alertVip()
            return
        }
		let speech = SpeechViewController.init()
		speech.episode = self.episode
		FMPlayerManager.shared.isPlay ? FMPlayerManager.shared.pause() : FMPlayerManager.shared.play()
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


extension FunctionsViewController {
	
	func setUpPlayToolbar() {
		self.view.backgroundColor = R.color.background()!
		self.playToolbar = PlayDetailToolBar.init(episode: self.episode)
		self.playToolbar.delegate = self
		self.view.addSubview(self.playToolbar)
		self.headerPanel = self.playToolbar
		self.playToolbar.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
			make.centerX.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalTo(80.auto())
		}
		self.view.layoutIfNeeded()
		self.headerHeight = self.playToolbar.constraints.filter({ (constraint) -> Bool in
			return constraint.constant == 80.auto()
		}).first!
	}
	
	func setUpPageViews() {
		let style = PageStyle()
		style.isTitleViewScrollEnabled = true
		style.isTitleScaleEnabled = true
		style.titleSelectedColor = R.color.titleColor()!
		style.titleColor = R.color.subtitle()!
		style.titleFont = p_bfont(18)
		style.titleMaximumScaleFactor = 1.2
		style.contentViewBackgroundColor = .clear
		style.titleViewBackgroundColor = .clear

		let titles = ["偏好", "均衡器"]
		let childViewControllers: [UIViewController] = [PerferenceViewController(), UIViewController()]
		var frame = self.view.frame
		frame.origin.y = self.headerHeight.constant + UIApplication.safeAreaBottom()
		let pageView = PageView(frame: frame, style: style, titles: titles, childViewControllers: childViewControllers)
		view.addSubview(pageView)
	}
	
}
