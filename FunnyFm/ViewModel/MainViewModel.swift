//
//  MainViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import OneSignal


@objc protocol MainViewModelDelegate: ViewModelDelegate {
	func viewModelDidGetChapterlistSuccess()
	func viewModelDidGetAdlistSuccess()
}


class MainViewModel: NSObject {	
	
    
    weak var delegate : MainViewModelDelegate?
    
    override init() {
        super.init()
		
    }
	
	func getAd(vc: UIViewController){
//		let options = GADMultipleAdsAdLoaderOptions()
//		options.numberOfAds = 5
//		let adLoader = GADAdLoader(adUnitID: "ca-app-pub-9733320345962237/5831665620",
//							   rootViewController: vc,
//							   adTypes: [.unifiedNative],
//							   options: [options])
//		adLoader.delegate = self
//		adLoader.load(GADRequest())
	}
    
    func refresh() {
        FeedManager.shared.getAllPods()
    }
	
	func refreshWithNoNetwork(){
//		self.podlist = DatabaseManager.allItunsPod()
//		self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
	}
    

	
	
}



