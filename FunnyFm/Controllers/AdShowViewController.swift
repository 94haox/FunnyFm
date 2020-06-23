//
//  AdShowViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/5.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import AdSupport

class AdShowViewController: UIViewController {
	
	var topAd : FBAdView!
	
	var bottomAd : FBAdView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		self.navigationController?.setNavigationBarHidden(true, animated: true)
		topAd = FBAdView(placementID: "2429648340658960_2452422801714847", adSize: kFBAdSizeHeight250Rectangle, rootViewController: self)
		topAd.delegate = self
		topAd.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 250)
		view.addSubview(topAd)
		topAd.loadAd()
		//2429648340658960_2453422351614892
		bottomAd = FBAdView(placementID: "2429648340658960_2453422351614892", adSize: kFBAdSizeHeight250Rectangle, rootViewController: self)
		bottomAd.delegate = self
		bottomAd.frame = CGRect(x: 0, y: kScreenHeight-250, width: kScreenWidth, height: 250)
		view.addSubview(bottomAd)
		bottomAd.loadAd()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	
	func loadInsertAd(){
		
	}
	
	@IBAction func showFullScreenAd(_ sender: Any) {
		

	}
	
	@IBAction func backAction(_ sender: Any) {
		self.navigationController?.popViewController()
	}
}


extension AdShowViewController: FBAdViewDelegate {
	
	func adViewDidLoad(_ adView: FBAdView) {
		
	}
	
	func adView(_ adView: FBAdView, didFailWithError error: Error) {
		print(error)
	}
	
	
}





