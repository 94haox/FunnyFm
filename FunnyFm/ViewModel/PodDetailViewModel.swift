//
//  PodDetailViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/16.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

@objc protocol PodDetailViewModelDelegate :ViewModelDelegate {
	func podDetailParserSuccess()
	func podDetailCancelSubscribeSuccess()
}

class PodDetailViewModel: NSObject {
	
	weak var delegate : PodDetailViewModelDelegate?

	var episodeList : [Episode]!
	
	func parserNewChapter(pod: iTunsPod){
		self.episodeList = DatabaseManager.allEpisodes(pod: pod)
		self.delegate?.podDetailParserSuccess()
		FeedManager.shared.parserRss(pod) { (podlist) in
			self.episodeList = DatabaseManager.allEpisodes(pod: pod)
			self.delegate?.podDetailParserSuccess()
		}
	}
	
	func cancelSubscribe(collectionId: String) {
		DatabaseManager.deleteItunsPod(collectionId: collectionId)
		self.delegate?.podDetailCancelSubscribeSuccess()
	}
	
}
