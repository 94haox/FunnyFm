//
//  PodDetailViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/16.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import OneSignal

@objc protocol PodDetailViewModelDelegate :ViewModelDelegate {
	func podDetailParserSuccess()
	func podDetailCancelSubscribeSuccess()
}

class PodDetailViewModel: NSObject {
	
	weak var delegate : PodDetailViewModelDelegate?

	var episodeList : [Episode]!
	
	var pod: iTunsPod?
	
	func parserNewChapter(pod: iTunsPod){
		self.pod = pod
		self.episodeList = DatabaseManager.allEpisodes(pod: pod)
		self.delegate?.podDetailParserSuccess()
		FeedManager.shared.delegate = self
		FeedManager.shared.parserForSingle(feedUrl: pod.feedUrl, collectionId: pod.collectionId)
		
	}
	
	func cancelSubscribe(collectionId: String) {
		DatabaseManager.deleteItunsPod(collectionId: collectionId)
		self.delegate?.podDetailCancelSubscribeSuccess()
	}
	
}

extension PodDetailViewModel : FeedManagerDelegate {
	
	func feedManagerDidGetEpisodelistSuccess() {
		self.episodeList = DatabaseManager.allEpisodes(pod: self.pod!)
		self.delegate?.podDetailParserSuccess()
	}
	
	func feedManagerDidParserPodcasrSuccess(){
		
	}
	
}
