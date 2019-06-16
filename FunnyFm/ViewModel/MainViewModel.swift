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
    
    lazy var episodeList : [Episode] = {
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
		let podList = DatabaseManager.allItunsPod()
		
		podList.forEach { (pod) in
			FeedManager.shared.parserRss(pod, {(episodeList) in
				self.episodeList.append(contentsOf: episodeList)
//				self.episodeList.sort { (obj1, obj2) -> Bool in
//					let obj1Date = NSDate.init(from: obj1.pubDate)
//					let obj2Date = NSDate.init(from: obj2.pubDate)
//				}
				DispatchQueue.main.async {
					self.delegate?.viewModelDidGetDataSuccess()
				}
			})
		}
		
    }
    

}
