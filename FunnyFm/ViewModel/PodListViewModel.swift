//
//  PodListViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

@objc protocol PodListViewModelDelegate: ViewModelDelegate {
	func didSyncSuccess(index:Int)
}

class PodListViewModel: NSObject {
	
	weak var delegate: PodListViewModelDelegate?

    var podlist : [iTunsPod] = []
	
	var itunsPodlist : [iTunsPod] = []
	
	var syncList: [iTunsPod] = []
	
	var topics = ["Arts".localized, "Business".localized, "Comedy".localized, "Education".localized, "Kids & Family".localized, "Music".localized, "Religion & Spirituality".localized, "Society & Culture".localized, "Technology".localized]
	var topicIDs = ["1301", "1321", "1303", "1304", "1305", "1310", "1314", "1324", "1318"]
	var topicIcons = ["art", "business", "comedy", "edu", "game", "govern", "health", "kids", "music-cate", "news", "pray", "science", "society", "ball", "tech", "tv"]

    
}

// MARK: - Subscribe
extension PodListViewModel {
	
	func syncSubscribelist(podidList: [String]){
		var podCount = 0
		podidList.forEach { (podId) in
			DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
				FmHttp<User>().requestForSingle(UserAPI.addSubscribe(podId), { (_) in
					podCount += 1
					DispatchQueue.main.async {
						self.delegate?.didSyncSuccess(index: podCount)
					}
				}, { (msg) in
					podCount += 1
					DispatchQueue.main.async {
						self.delegate?.didSyncSuccess(index: podCount)
					}
				})
			}
		}
	}
	
	func getAllSubscribe(){
		if !UserCenter.shared.isLogin {
			self.podlist = DatabaseManager.allItunsPod()
			self.delegate?.viewModelDidGetDataSuccess()
			return
		}
		FmHttp<iTunsPod>().requestForArray(UserAPI.getSubscribeList,{ podlist in
			if podlist.isSome {
				self.podlist = DatabaseManager.allItunsPod()
				self.syncList = podlist!
				var idList = [String]()
				self.podlist.forEach({ (pod) in
					idList.append(pod.feedUrl)
				})
				
				podlist!.forEach({ (pod) in
					if idList.contains(pod.feedUrl) {
						let index = idList.index(of: pod.feedUrl)
						if index.isSome {
							self.podlist.remove(at: index!)
							idList.remove(at: index!)
						}
					}
				})
			}
			
			DispatchQueue.main.async {
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}){ msg in
			self.delegate?.viewModelDidGetDataFailture(msg: msg)
		}
	}
	
	func registerPod(params: Dictionary<String, String>, success:@escaping SuccessStringClosure, failure: @escaping FailClosure){
		FmHttp<iTunsPod>().requestForSingle(PodAPI.registerPod(params), { (pod) in
			if pod.isSome {
				var dbpod = DatabaseManager.getPodcast(feedUrl: pod!.feedUrl)
				if dbpod.isSome {
					dbpod!.podId = pod!.podId
					DatabaseManager.updateItunsPod(pod: dbpod!)
				}
			}
			
			success("success")
		}) { (msg) in
			failure(msg)
		}
	}
	
}


// MARK: - search
extension PodListViewModel {
	
	func searchPod(keyword:String){
		FmHttp<iTunsPod>().requestForItunes(PodAPI.searchPod(keyword), { (podlist) in
			if let list = podlist {
				self.itunsPodlist = list
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}){ msg in
			self.itunsPodlist.removeAll()
			self.delegate?.viewModelDidGetDataFailture(msg: msg)
		}
	}
	
	func searchTopic(keyword:String){
		FmHttp<iTunsPod>().requestForItunes(PodAPI.searchTopic(keyword), { (podlist) in
			if let list = podlist {
				self.itunsPodlist = list
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}){ msg in
			self.delegate?.viewModelDidGetDataFailture(msg: msg)
		}
	}
	
}
