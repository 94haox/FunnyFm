//
//  PodListViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class PodListViewModel: BaseViewModel {

    lazy var podlist : [iTunsPod] = {
        return []
    }()
	
	lazy var itunsPodlist : [iTunsPod] = {
		return []
	}()
    
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
    
}
