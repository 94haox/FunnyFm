//
//  AdShowViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/5.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

//8020580224686001

//7050583255877020

//1109760306

class AdShowViewController: UIViewController {
	
	var topAd : GDTUnifiedBannerView!
	
	var bottomAd : GDTUnifiedBannerView!
	
	private var interstitial: GDTMobInterstitial?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = R.color.background()
		let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
		topAd = GDTUnifiedBannerView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: kScreenWidth, height: 100), appId: "1109760306", placementId: "8020580224686001", viewController: self)
		bottomAd = GDTUnifiedBannerView.init(frame: CGRect.init(x: 0, y: kScreenHeight-100, width: kScreenWidth, height: 100), appId: "1109760306", placementId: "7050583255877020", viewController: self)
		self.view.addSubview(topAd)
		self.view.addSubview(bottomAd)
		topAd.delegate = self;
		bottomAd.delegate = self;
		topAd.loadAdAndShow()
		bottomAd.loadAdAndShow()
		self.loadInsertAd()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		FMToolBar.shared.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if FMToolBar.shared.currentEpisode.isSome {
			FMToolBar.shared.isHidden = false
		}
	}
	
	
	func loadInsertAd(){
		if (interstitial != nil) {
			interstitial?.delegate = nil
			interstitial = nil
		}
		interstitial = GDTMobInterstitial.init(appId: "1109760306", placementId: "4010384935083869")
		interstitial?.delegate = self

		interstitial?.loadAd()
	}
	
	@IBAction func showFullScreenAd(_ sender: Any) {
		
		interstitial?.present(fromRootViewController: self)
	}
	
	@IBAction func backAction(_ sender: Any) {
		self.navigationController?.popViewController()
	}
}

extension AdShowViewController: GDTUnifiedBannerViewDelegate{
	
	func unifiedBannerViewDidLoad(_ unifiedBannerView: GDTUnifiedBannerView) {
		
	}
	
	func unifiedBannerViewFailed(toLoad unifiedBannerView: GDTUnifiedBannerView, error: Error) {
		print(error.localizedDescription)
	}
	
}

extension AdShowViewController: GDTMobInterstitialDelegate{
	func interstitialSuccess(toLoadAd interstitial: GDTMobInterstitial!) {
		
	}
	
	func interstitialFail(toLoadAd interstitial: GDTMobInterstitial!, error: Error!) {
		print(error.localizedDescription)
	}
}





