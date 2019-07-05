//
//  MainViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit




class MainViewModel: NSObject {
    
    lazy var podlist : [iTunsPod] = {
       return DatabaseManager.allItunsPod()
    }()
    
    lazy var episodeList : [[Episode]] = {
        return []
    }()
    
    weak var delegate : ViewModelDelegate?
    
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
				self.getHomeChapters()
				self.delegate?.viewModelDidGetDataSuccess()
			}){ msg in
				self.podlist = DatabaseManager.allItunsPod()
				self.getHomeChapters()
				self.delegate?.viewModelDidGetDataFailture(msg: msg)
			}
		}else{
			self.podlist = DatabaseManager.allItunsPod()
			self.getHomeChapters()
			DispatchQueue.main.async {
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}
		
    }
    
    func getHomeChapters() {
		DispatchQueue.global().async {
			self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
			DispatchQueue.main.async {
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}

		DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
			let start = Date().timeIntervalSince1970
			let podList = DatabaseManager.allItunsPod()
			var episodeList = [Episode]()
			podList.forEach { (pod) in
				let list = FeedManager.shared.parserRssSync(pod)
				episodeList.append(contentsOf: list)
			}
			self.episodeList = self.sortEpisodeToGroup(episodeList)
			DispatchQueue.main.async {
				self.delegate?.viewModelDidGetDataSuccess()
			}
			print("parse time------", Date().timeIntervalSince1970 - start)
		}
		
    }
	
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) -> [[Episode]]{
		let start = Date().timeIntervalSince1970
		var dateList = [String]()
		var timeList = [Double]()
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
		
		print("time------", Date().timeIntervalSince1970 - start)
		return sortEpisodeList
	}
    

}
