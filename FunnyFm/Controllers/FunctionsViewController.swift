//
//  FunctionsViewController.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/5/29.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import DNSPageView

class FunctionsViewController: UIViewController, Panelable {
    
    var panel: Panels?
    
    var arrow: ArrowView! = ArrowView.init(frame: CGRect(x: 0, y: 0, width: 25.auto(), height: 25.auto()))
	
	var playToolbar: PlayDetailToolBar!
	
	var headerHeight: NSLayoutConstraint!
	
	var episode: Episode!
	
	var headerPanel: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addBlurBackground()
		self.curveTopCorners()
        self.setUpHeaderView()
		self.setUpPlayToolbar()
		self.setUpPageViews()
        self.arrow.update(to: .up, animated: true)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playToolbar.downBtn.isSelected = DatabaseManager.qureyDownload(title: self.episode.title).isSome
    }
	
}


extension FunctionsViewController: PanelNotifications {
    
    func panelChanging() {
        self.arrow.update(to: .middle, animated: true)
    }
    
    func panelDidPresented() {
        
    }
    
    func panelDidCollapse() {
        self.arrow.update(to: .up, animated: true)
    }
    
    func panelDidOpen() {
        self.arrow.update(to: .down, animated: true)
    }
    
}

//extension FunctionsViewController {
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let point = touches.first!.location(in: self.view)
//        print("start-----\(point.y)")
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let point = touches.first!.location(in: self.view)
//        let prePoint = touches.first!.preciseLocation(in: self.view)
//        let y = point.y - prePoint.y
//        self.panel!.movePanelHeader(value: y)
//        print("moved-----\(y)")
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let point = touches.first!.location(in: self.view)
//        print("cancel-----\(point.y)")
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let point = touches.first!.location(in: self.view)
//        print("end-----\(point.y)")
//    }
//    
//    
//}

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
    
    func setUpHeaderView() {
        let view = UIView()
        self.view.addSubview(view)
        self.headerPanel = view
        view.snp.makeConstraints { (make) in
            make.top.leading.width.equalToSuperview()
            make.height.equalTo(80.auto())
        }
        self.view.layoutIfNeeded()
        self.headerHeight = view.constraints.filter({ (constraint) -> Bool in
            return constraint.constant == 80.auto()
        }).first!
    }
	
	func setUpPlayToolbar() {
		self.playToolbar = PlayDetailToolBar.init(episode: self.episode)
		self.playToolbar.delegate = self
		self.headerPanel.addSubview(self.playToolbar)
        self.headerPanel.addSubview(self.arrow)
        self.arrow.arrowColor = .white
        
        self.arrow.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4.auto())
            make.width.equalTo(25.auto())
            make.height.equalTo(25.auto())
        }
        
		self.playToolbar.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-30.auto())
			make.height.equalTo(60.auto())
		}

	}
	
	func setUpPageViews() {
		let style = PageStyle()
		style.isTitleViewScrollEnabled = true
		style.isTitleScaleEnabled = true
		style.titleSelectedColor = R.color.titleColor()!
		style.titleColor = R.color.subtitle()!
		style.titleFont = p_bfont(18)
		style.titleMaximumScaleFactor = 1.2
        style.titleViewBackgroundColor = .clear
        style.contentViewBackgroundColor = .clear
        
		let titles = ["偏好", "均衡器"]
		let childViewControllers: [UIViewController] = [PerferenceViewController(), UIViewController()]
		var frame = self.view.frame
        frame.origin.y = self.headerHeight.constant + 12.auto()
        frame.origin.x = 30.auto()/2.0
        frame.size.width = kScreenWidth - 30.auto()
        frame.size.height = 400.auto() - self.headerHeight.constant - 12.auto()
		let pageView = PageView(frame: frame, style: style, titles: titles, childViewControllers: childViewControllers)
		view.addSubview(pageView)
        pageView.curveCorners(.allCorners, cornerRadii: CGSize(width: 15.auto(), height: 15.auto()))
	}
	
}
