//
//  MainViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit


@objc protocol MainViewModelDelegate: ViewModelDelegate {
	func viewModelDidGetChapterlistSuccess()
}


class MainViewModel: NSObject {
	
	var isParserChapter = true
    
    lazy var podlist : [iTunsPod] = {
       return DatabaseManager.allItunsPod()
    }()
    
    lazy var episodeList : [[Episode]] = {
        return []
    }()
    
    weak var delegate : MainViewModelDelegate?
    
    override init() {
        super.init()
    }
    
    func refresh() {
        self.getAllPods()
    }
    
    func getAllPods() {
		if UserCenter.shared.isLogin {
			FmHttp<iTunsPod>().requestForArray(PodAPI.getPodList, { (cloudPodlist) in
				if let list = cloudPodlist {
					list.forEach({ (pod) in
						DatabaseManager.addItunsPod(pod: pod)
					})
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
		let start = Date().timeIntervalSince1970
		let podList = DatabaseManager.allItunsPod()
		
		
		podList.forEach { (pod) in
			print("fetch")
			group.enter()
//			FeedManager.shared.parserRss(pod, { (podlist) in
//				self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
//				DispatchQueue.main.async {
//					self.delegate?.viewModelDidGetChapterlistSuccess()
//				}
//				group.leave()
//			})
			queue.async(group: group, qos: DispatchQoS.userInteractive, flags: []) {
				FeedManager.shared.parserRss(pod, { (podlist) in
					
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
				self.isParserChapter = false
				self.delegate?.viewModelDidGetChapterlistSuccess()
			}
			print("parse time------", Date().timeIntervalSince1970 - start)
		}
		
    }
	
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) -> [[Episode]]{
		var dateList = [String]()
		var timeList = [Int]()
		var sortEpisodeList = [[Episode]]()
		episodeList.forEach { (episode) in
			if !dateList.contains(episode.pubDate) {
				dateList.append(episode.pubDate)
				timeList.append(episode.pubDateSecond)
			}
		}
		
		timeList.sort(by: {$0 > $1})
		timeList.forEach { (pubDateSecond) in
			var list = [Episode]()
			episodeList.forEach { (episode) in
				if episode.pubDateSecond == pubDateSecond {
					list.append(episode)
				}
			}
			sortEpisodeList.append(list)
		}
		
		return sortEpisodeList
	}
    

}
