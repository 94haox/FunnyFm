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

	var episodeList : [Episode] = [Episode]()
	
	var pod: iTunsPod?
	
	var collectionList: [PodcastCollection] = [PodcastCollection]()
	
	override init() {
		super.init()
	}
	
	init(podcast: iTunsPod) {
		super.init()
        self.pod = DatabaseManager.getPodcast(feedUrl: podcast.feedUrl)
        self.isNeedVpn()
		self.delegate?.podDetailParserSuccess()
	}
	
	func parserNewChapter(pod: iTunsPod){
		self.pod = pod
		self.episodeList = DatabaseManager.allEpisodes(pod: pod)
		self.delegate?.podDetailParserSuccess()
		FeedManager.shared.delegate = self
        if self.pod!.isNeedVpn {
            FeedManager.shared.parserByFeedKit(podcast: pod, complete: { isSuccess in
                self.episodeList = DatabaseManager.allEpisodes(pod: pod)
                self.pod = DatabaseManager.getPodcast(feedUrl: pod.feedUrl)
                self.pod?.trackCount = "\(self.episodeList.count)"
                self.delegate?.podDetailParserSuccess()
            })
        }else{
            FeedManager.shared.parserForSingle(feedUrl: pod.feedUrl, collectionId: pod.collectionId) { (podcast) in
                if let podcast_receive = podcast, podcast_receive.podId.length() > 0 {
                    self.pod = DatabaseManager.getPodcast(feedUrl:pod.feedUrl)
                    self.pod?.podDes = podcast!.description
                    self.pod?.trackCount = "\(self.episodeList.count)"
                    self.pod!.isNeedVpn = false
                }else{
                    self.pod!.isNeedVpn = true
                    self.parserNewChapter(pod: self.pod!)
                }
                DatabaseManager.updateItunsPod(pod: self.pod!)
                self.delegate?.podDetailParserSuccess()
            }
        }
	}
	
	func getPodcastPrev(pod: iTunsPod){
		self.pod = pod
		FmHttp<iTunsPod>().requestForSingle(PodAPI.getPodcastPrev(pod.feedUrl), { (json) in
			var data = json["data"]
			if data["detail"]["rss_url"].stringValue.length() < 1{
				data["detail"]["rss_url"].stringValue = pod.feedUrl
			}
			self.pod = iTunsPod.init(jsonData: data["detail"])
			data["detail"]["items"].arrayValue.forEach({ (item) in
				let t = Episode.init(jsonData:item)!
				self.episodeList.append(t)
			})
			self.delegate?.podDetailParserSuccess()
		},nil)
	}
	
	func getPrev(feedUrl: String) {
		self.episodeList.removeAll()
		self.pod = nil
		FmHttp<iTunsPod>().requestForSingle(PodAPI.getPodcastPrev(feedUrl), { (json) in
			var data = json["data"]
			
			if data["detail"].dictionaryValue.count < 2{
				SwiftNotice.showText("Podcast 尚未找到")
				return
			}
			
			if data["detail"]["rss_url"].stringValue.length() < 1{
				data["detail"]["rss_url"].stringValue = feedUrl
			}
			self.pod = iTunsPod.init(jsonData: data["detail"])
			data["detail"]["items"].arrayValue.forEach({ (item) in
				let t = Episode.init(jsonData:item)!
				self.episodeList.append(t)
			})
			self.delegate?.podDetailParserSuccess()
		},nil)
	}
	
	func cancelSubscribe(feedUrl: String) {
		DatabaseManager.deleteItunsPod(feedUrl: feedUrl)
		self.delegate?.podDetailCancelSubscribeSuccess()
	}
	
	func getAllRecommends(){
		FmHttp<PodcastCollection>().requestForArray(GeneralAPI.getRecommends, { (collectionList) in
			if collectionList.isSome{
				self.collectionList = collectionList!
			}
			self.delegate?.viewModelDidGetDataSuccess()
		}) { (error) in
			self.delegate?.viewModelDidGetDataFailture(msg: error)
		}
	}
    
    func isNeedVpn() {
        self.episodeList = DatabaseManager.allEpisodes(pod: self.pod!)
        if let episode = self.episodeList.first{
            guard episode.trackUrl.contains("anchor.fm") || episode.trackUrl.contains("soundcloud") else {
                return
            }
            self.pod!.isNeedVpn = true
            DatabaseManager.updateItunsPod(pod: self.pod!)
        }
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
