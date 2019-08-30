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
	
	var isParsering = false
	
    lazy var podlist : [iTunsPod] = {
       return DatabaseManager.allItunsPod()
    }()
    
    lazy var episodeList : [[Any]] = {
        return []
    }()
	
	var nativeAds = [GADUnifiedNativeAd]()
	
	lazy var radioList: [Dictionary] = {
		return [["name":"BlackBeats.FM","url":"http://stream.blackbeats.fm/"],
			["name":"Classical Minnesota","url":"http://cms.stream.publicradio.org/cms.mp3"],
			["name":"Blues.FM","url":"http://sc2b-sjc.1.fm:8030/"]
		]
	}()
    
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
        self.getAllPods()
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


extension MainViewModel {
	
	func getAllPods() {
		if UserCenter.shared.isLogin {
			FmHttp<iTunsPod>().requestForArray(PodAPI.getPodList, { (cloudPodlist) in
				if let list = cloudPodlist {
					var taglist = [AnyHashable: Any]()
					list.forEach({ (pod) in
						taglist[pod.podId] = "1"
						DatabaseManager.addItunsPod(pod: pod)
					})
					
					PushManager.shared.addTag(taglist: taglist)
				}
				
				self.podlist = DatabaseManager.allItunsPod()
				self.delegate?.viewModelDidGetDataSuccess()
				self.getHomeChapters()
			}){ msg in
				self.podlist = DatabaseManager.allItunsPod()
				self.delegate?.viewModelDidGetDataFailture(msg: msg)
				self.getHomeChapters()
			}
		}else{
			PushManager.shared.removeAllTages()
			self.podlist = DatabaseManager.allItunsPod()
			DispatchQueue.main.async {
				self.delegate?.viewModelDidGetDataSuccess()
			}
			self.getHomeChapters()
		}
		
	}
	
	func getHomeChapters() {
		DispatchQueue.global().async {
			self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
			if self.episodeList.count > 0 {
				DispatchQueue.main.async {
					self.delegate?.viewModelDidGetChapterlistSuccess()
				}
			}
		}
		
		
		let group = DispatchGroup.init()
		let queue = DispatchQueue.init(label: "parser")
		let podList = DatabaseManager.allItunsPod()
		
		if self.isParsering{
			return
		}else if podList.count > 0{
			self.isParsering = true
		}else{
			self.delegate?.viewModelDidGetChapterlistSuccess()
			return;
		}
		
		let trace = Performance.startTrace(name: "parserRss")
		trace?.incrementMetric("parser", by: 1)
		NotificationCenter.default.post(name: NSNotification.Name.init("homechapterParserBegin"), object: nil)
		podList.forEach { (pod) in
			print("fetch")
			group.enter()
			queue.async(group: group, qos: DispatchQoS.userInteractive, flags: []) {
				FeedManager.shared.parserRss(pod, { (episodeList) in
					
					print("fetched")
					self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
					DispatchQueue.main.async {
						self.delegate?.viewModelDidGetChapterlistSuccess()
					}
					group.leave()
				})
				
			}
		}
		
		group.notify(queue: queue) {
			DispatchQueue.main.async {
				self.isParsering = false
				NotificationCenter.default.post(name: NSNotification.Name.init("homechapterParserSuccess"), object: nil)
				self.delegate?.viewModelDidGetChapterlistSuccess()
			}
			trace?.stop()
		}
		
	}
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) -> [[Episode]]{
		
		let trace = Performance.startTrace(name: "sortEpisodeList")
		trace?.incrementMetric("sort", by: 1)
		
		var episodes = episodeList.suffix(100)
		episodes.sort(){$0.pubDateSecond < $1.pubDateSecond}
		var sortEpisodeList = [[Episode]]()
		
		var dic : [String: [Episode]] = [:]
		var index = 0;
		episodes.forEach { (episode) in
			var list = dic[episode.pubDate]
			if list.isSome {
				list!.append(episode)
			}else{
				list = Array.init()
				list!.append(episode)
				index += 1
			}
			dic[episode.pubDate] = list!
			if sortEpisodeList.count < index{
				sortEpisodeList.append(list!)
			}else{
				sortEpisodeList.remove(at: index-1)
				sortEpisodeList.append(list!)
			}
		}
		
		trace?.stop()
		return sortEpisodeList
	}

}
