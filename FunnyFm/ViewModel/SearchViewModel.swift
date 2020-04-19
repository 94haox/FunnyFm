//
//  SearchViewModel.swift
//  FunnyFm
//
//  Created by wt on 2020/4/19.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {

    weak var delegate: PodListViewModelDelegate?
    
    var itunsPodlist  = [iTunsPod]()
    
    lazy var seachHistories: [String] = {
        guard let history = UserDefaults.standard.stringArray(forKey: "searchHistories") else {
            return [String]()
        }
        return history
    }()
    
    func removeHistory(index: Int) {
        self.seachHistories.remove(at: index)
        UserDefaults.standard.set(self.seachHistories, forKey: "searchHistories")
    }
    
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
        
        if keyword.count < 3 {
            return
        }
        if var histories = UserDefaults.standard.stringArray(forKey: "searchHistories"){
            if histories.contains(keyword) {
                return
            }
            histories.append(keyword)
            if histories.count > 5 {
                histories = Array(histories.dropFirst())
            }
            UserDefaults.standard.set(histories, forKey: "searchHistories")
        }else{
            UserDefaults.standard.set([keyword], forKey: "searchHistories")
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
