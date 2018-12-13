//
//  PodListViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class PodListViewModel: NSObject {

    lazy var podlist : [Pod] = {
        return []
    }()
    
    weak var delegate : ViewModelDelegate?
    
    override init() {
        super.init()
    }
    
    func getAllPods() {
        FmHttp<Pod>().requestForArray(PodAPI.getPodList(), { (podlist) in
            if let list = podlist {
                self.podlist = list
                self.delegate?.viewModelDidGetDataSuccess()
            }
        }){ msg in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }
    
}
