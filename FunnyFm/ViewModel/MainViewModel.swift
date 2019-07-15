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
	
	var isParsering = false
	
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
		
		if self.isParsering{
			return
		}else if podList.count > 0{
			self.isParsering = true
		}else{
			return;
		}
		
		NotificationCenter.default.post(name: NSNotification.Name.init("homechapterParserBegin"), object: nil)
		podList.forEach { (pod) in
			print("fetch")
			group.enter()
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
				self.isParsering = false
				NotificationCenter.default.post(name: NSNotification.Name.init("homechapterParserSuccess"), object: nil)
				self.delegate?.viewModelDidGetChapterlistSuccess()
			}
			print("parse time------", Date().timeIntervalSince1970 - start)
		}
		
    }
	
	
	func sortEpisodeToGroup(_ episodeList: [Episode]) -> [[Episode]]{
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
		
		return sortEpisodeList
	}
    

}
