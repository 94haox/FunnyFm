//
//  GlobalViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/2/17.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class GlobalViewModel: BaseViewModel {
	
	static let shared = GlobalViewModel()
	
	var importPod: Pod!
	
	func getPrePodFromItuns(podId:String, source:String) {
		
		FmHttp<Pod>().requestForSingle(PodAPI.checkPodSource(podId, source), success: { (pod) in
			if pod.isSome {
				self.importPod = pod
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}, { (message) in
			self.delegate?.viewModelDidGetDataFailture(msg: message)
		})
		
	}
	
	func addItunesPod(podId:String, feedUrl:String,sourceType:String) {
		FmHttp<Pod>().requestForSingle(PodAPI.addPodSource(podId, feedUrl, sourceType), success: { (pod) in
			if pod.isSome {
				self.delegate?.viewModelDidGetDataSuccess()
			}
		}, { (message) in
			self.delegate?.viewModelDidGetDataFailture(msg: message)
		})
		
	}
	

}
