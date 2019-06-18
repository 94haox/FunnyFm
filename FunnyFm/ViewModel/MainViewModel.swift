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
       return []
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
        self.getHomeChapters()
    }
    
    func getAllPods() {
		if UserCenter.shared.isLogin {
			FmHttp<iTunsPod>().requestForArray(PodAPI.getPodList(), { (podlist) in
				if let list = podlist {
					self.podlist = list
					self.delegate?.viewModelDidGetDataSuccess()
				}
			}){ msg in
				self.delegate?.viewModelDidGetDataFailture(msg: msg)
			}
		}else{
			self.podlist = DatabaseManager.allItunsPod()
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

			let podList = DatabaseManager.allItunsPod()
			var episodeList = [Episode]()
			podList.forEach { (pod) in
				let list = FeedManager.shared.parserRssSync(pod)
				episodeList.append(contentsOf: list)
				print("episode count = \(list.count)")
			}
			self.episodeList = self.sortEpisodeToGroup(episodeList)
			DispatchQueue.main.async {
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}
		
    }
	
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) -> [[Episode]]{
		
		var dateList = [String]()
		var sortEpisodeList = [[Episode]]()
		episodeList.forEach { (episode) in
			if !dateList.contains(episode.pubDate) {
				dateList.append(episode.pubDate)
			}
		}
		
		dateList.forEach { (pubDate) in
			var list = [Episode]()
			episodeList.forEach { (episode) in
				if episode.pubDate == pubDate {
					list.append(episode)
				}
			}
			sortEpisodeList.append(list)
		}
		return sortEpisodeList
	}
    

}
