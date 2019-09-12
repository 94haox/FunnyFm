//
//  MainViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import OneSignal
import FirebasePerformance
import GoogleMobileAds


@objc protocol MainViewModelDelegate: ViewModelDelegate {
	func viewModelDidGetChapterlistSuccess()
	func viewModelDidGetAdlistSuccess()
}


class MainViewModel: NSObject {	
	
	var nativeAds = [GADUnifiedNativeAd]()
    
    weak var delegate : MainViewModelDelegate?
    
    override init() {
        super.init()
		
    }
	
	func getAd(vc: UIViewController){
		let options = GADMultipleAdsAdLoaderOptions()
		options.numberOfAds = 5
		let adLoader = GADAdLoader(adUnitID: "ca-app-pub-9733320345962237/5831665620",
							   rootViewController: vc,
							   adTypes: [.unifiedNative],
							   options: [options])
		adLoader.delegate = self
		adLoader.load(GADRequest())
	}
    
    func refresh() {
        FeedManager.shared.getAllPods()
    }
	
	func refreshWithNoNetwork(){
//		self.podlist = DatabaseManager.allItunsPod()
//		self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
	}
    

	
	
}

extension MainViewModel: GADUnifiedNativeAdLoaderDelegate{
	
	func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
		print("\(adLoader) failed with error: \(error.localizedDescription)")
	}
	
	func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
		print("Received native ad: \(nativeAd)")
		
		// Add the native ad to the list of native ads.
		nativeAds.append(nativeAd)
	}
	
	func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
		self.delegate?.viewModelDidGetAdlistSuccess()
	}
	
}



