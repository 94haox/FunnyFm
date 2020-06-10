//
//  AdShowViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/5.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import MoPub

//8020580224686001

//7050583255877020

//1109760306

class AdShowViewController: UIViewController {
	
	var topAd : MPAdView!
	
	var bottomAd : MPAdView!
	
	private var interstitial: MPInterstitialAdController?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = R.color.background()
		topAd = MPAdView.init(adUnitId: "513cebe42e774a029dab367069ab52e2")
		topAd.delegate = self
		topAd.frame = CGRect(x: 0, y: 64, width: kMPPresetMaxAdSize50Height.width, height: kMPPresetMaxAdSize50Height.height)
		view.addSubview(topAd)
		topAd.loadAd(withMaxAdSize: kMPPresetMaxAdSizeMatchFrame)
		
//		bottomAd = MPAdView.init(adUnitId: "458a22fc08574ae98065ed2fe78de927")
//		bottomAd.delegate = self
//		bottomAd.frame = CGRect(x: 0, y: kScreenHeight-kMPPresetMaxAdSize50Height.height, width: kMPPresetMaxAdSize50Height.width, height: kMPPresetMaxAdSize50Height.height)
//		view.addSubview(bottomAd)
//		bottomAd.loadAd(withMaxAdSize: kMPPresetMaxAdSizeMatchFrame)
//
		self.loadInsertAd()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	
	func loadInsertAd(){
		if (interstitial != nil) {
			interstitial?.delegate = nil
			interstitial = nil
		}
		interstitial = MPInterstitialAdController.init(forAdUnitId: "113f6153df1d4d6e8526fa18add6c730")
		interstitial?.delegate = self

		interstitial?.loadAd()
	}
	
	@IBAction func showFullScreenAd(_ sender: Any) {
		
		interstitial?.show(from: self)
	}
	
	@IBAction func backAction(_ sender: Any) {
		self.navigationController?.popViewController()
	}
}


extension AdShowViewController: MPAdViewDelegate {
	
	func viewControllerForPresentingModalView() -> UIViewController! {
		return self
	}
	
	func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
		print(error.localizedDescription)
	}
	
}

extension AdShowViewController: MPInterstitialAdControllerDelegate {
	
	func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
		print(error.localizedDescription)
	}
	
}





