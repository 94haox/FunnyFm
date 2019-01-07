//
//  MainViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit




class MainViewModel: NSObject {
    
    lazy var podlist : [Pod] = {
       return []
    }()
    
    lazy var chapterList : [Episode] = {
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
        FmHttp<Pod>().requestForArray(PodAPI.getPodList(), { (podlist) in
            if let list = podlist {
                self.podlist = list
                self.delegate?.viewModelDidGetDataSuccess()
            }
        }){ msg in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }
    
    func getHomeChapters() {
        FmHttp<Episode>().requestForArray(ChapterAPI.getHomeChapterList(), { (capterlist) in
            if let list = capterlist {
                self.chapterList = list
                self.delegate?.viewModelDidGetDataSuccess()
            }
        }){ msg in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }
    

}
