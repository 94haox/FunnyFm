//
//  AdShowViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/5.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import GoogleMobileAds


class AdShowViewController: UIViewController {
	
	var interstitial: GADInterstitial!
	var bottom_bannerView: GADBannerView!
	var top_bannerView: GADBannerView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		interstitial = GADInterstitial(adUnitID: screenAD)
		let request = GADRequest()
		interstitial.delegate = self
		interstitial.load(request)
		
		bottom_bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
		top_bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
		addBannerViewToView(bottom_bannerView)
		addTopBannerViewToView(top_bannerView)
	}
	
	
	func addBannerViewToView(_ bannerView: GADBannerView) {
		bannerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(bannerView)
		view.addConstraints(
			[NSLayoutConstraint(item: bannerView,
								attribute: .bottom,
								relatedBy: .equal,
								toItem: bottomLayoutGuide,
								attribute: .top,
								multiplier: 1,
								constant: 0),
			 NSLayoutConstraint(item: bannerView,
								attribute: .centerX,
								relatedBy: .equal,
								toItem: view,
								attribute: .centerX,
								multiplier: 1,
								constant: 0)
			])
		bannerView.adUnitID = topBannerAd
		bannerView.rootViewController = self
		bannerView.load(GADRequest())
	}
	
	
	func addTopBannerViewToView(_ bannerView: GADBannerView) {
		bannerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(bannerView)
		view.addConstraints(
			[NSLayoutConstraint(item: bannerView,
								attribute: .top,
								relatedBy: .equal,
								toItem: topLayoutGuide,
								attribute: .bottom,
								multiplier: 1,
								constant: 0),
			 NSLayoutConstraint(item: bannerView,
								attribute: .centerX,
								relatedBy: .equal,
								toItem: view,
								attribute: .centerX,
								multiplier: 1,
								constant: 0)
			])
		bannerView.adUnitID = bottomBannerAd
		bannerView.rootViewController = self
		bannerView.load(GADRequest())
	}
	@IBAction func showFullScreenAd(_ sender: Any) {
		if !interstitial.isReady {
			SwiftNotice.showText("广告加载中...".localized);
			return
		}
		interstitial.present(fromRootViewController: self)
	}
	@IBAction func backAction(_ sender: Any) {
		self.navigationController?.popViewController()
	}
}


extension AdShowViewController : GADInterstitialDelegate{
	func interstitialDidReceiveAd(_ ad: GADInterstitial) {
		
	}
	
	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
		
	}
}

