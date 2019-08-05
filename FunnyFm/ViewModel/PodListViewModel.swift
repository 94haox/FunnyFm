//
//  PodListViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import OneSignal

class PodListViewModel: BaseViewModel {

    lazy var podlist : [iTunsPod] = {
        return []
    }()
	
	lazy var itunsPodlist : [iTunsPod] = {
		return []
	}()
	
	var topics = ["Arts".localized, "Business".localized, "Comedy".localized, "Education".localized, "Games & Hobbies".localized, "Government & Organisations".localized, "Health".localized, "Kids & Family".localized, "Music".localized, "News & Politics".localized, "Religion & Spirituality".localized, "Science & Medicine".localized, "Society & Culture".localized, "Sports & Recreation".localized, "Technology".localized, "TV & Film".localized]
	var topicIDs = ["1301", "1321", "1303", "1304", "1323", "1325", "1307", "1305", "1310", "1311", "1314", "1315", "1324", "1316", "1318", "1309"]
	var topicIcons = ["art", "business", "comedy", "edu", "game", "govern", "health", "kids", "music-cate", "news", "pray", "science", "society", "ball", "tech", "tv"]
    
    override init() {
        super.init()
    }
    
    func getAllPods() {
		self.podlist = DatabaseManager.allItunsPod()
		self.delegate?.viewModelDidGetDataSuccess()
		
//        FmHttp<Pod>().requestForArray(PodAPI.getPodList(), { (podlist) in
//            if let list = podlist {
//                self.podlist = list
//                self.delegate?.viewModelDidGetDataSuccess()
//            }
//        }){ msg in
//            self.delegate?.viewModelDidGetDataFailture(msg: msg)
//        }
    }
	
	func searchPod(keyword:String){
		FmHttp<iTunsPod>().requestForItuns(PodAPI.searchPod(keyword), { (podlist) in
			if let list = podlist {
				self.itunsPodlist = list
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}){ msg in
			self.delegate?.viewModelDidGetDataFailture(msg: msg)
		}
	}
	
	func searchTopic(keyword:String){
		FmHttp<iTunsPod>().requestForItuns(PodAPI.searchTopic(keyword), { (podlist) in
			if let list = podlist {
				self.itunsPodlist = list
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}){ msg in
			self.delegate?.viewModelDidGetDataFailture(msg: msg)
		}
	}

	
	func registerPod(params: Dictionary<String, String>, success:@escaping SuccessStringClosure, failure: @escaping FailClosure){
		FmHttp<iTunsPod>().requestForSingle(PodAPI.registerPod(params), success: { (pod) in
			OneSignal.sendTag(pod!.podId, value: "1", onSuccess: { (tags) in}, onFailure: { (_) in})
			success("success")
		}) { (msg) in
			failure(msg)
		}
	}
    
}
