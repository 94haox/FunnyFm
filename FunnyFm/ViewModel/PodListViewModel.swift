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
	
//	var topics = ["作者推荐".localized]
//	var topicIDs = ["1301"]
//	var topicIcons = ["art"]
	
    override init() {
        super.init()
    }
    
    func getAllPods() {
		self.podlist = DatabaseManager.allItunsPod()
		self.delegate?.viewModelDidGetDataSuccess()
    }
	
	func searchPod(keyword:String){
		FmHttp<iTunsPod>().requestForItunes(PodAPI.searchPod(keyword), { (podlist) in
			if let list = podlist {
				self.itunsPodlist = list
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}){ msg in
			self.delegate?.viewModelDidGetDataFailture(msg: msg)
		}
	}
	
	func searchTopic(keyword:String){
		
//		let filepath = Bundle.main.path(forResource: "recommend", ofType: "json")
//		let url = URL(fileURLWithPath: filepath!)
//		do {
//			let data = try Data.init(contentsOf: url)
//			let json : NSArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
//
//			self.itunsPodlist.removeAll()
//			for dict in json {
//				self.itunsPodlist.append(iTunsPod.init(dic: dict as! NSDictionary))
//			}
//			self.delegate?.viewModelDidGetDataSuccess()
//		} catch let error {
//			print("读取本地数据出现错误!",error)
//		}


		FmHttp<iTunsPod>().requestForItunes(PodAPI.searchTopic(keyword), { (podlist) in
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
			success("success")
		}) { (msg) in
			failure(msg)
		}
	}
    
}
