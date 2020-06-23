//
//  AdsManager.swift
//  FunnyFm
//
//  Created by wt on 2020/3/23.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class AdsManager: NSObject {
    
    static let shared = AdsManager()
    
    var targetVc: MainViewController?
    
    var loadAccount = 5
    
    
    
    
        
    func loadAds(viewController: MainViewController) {
        guard !VipManager.shared.isVip else {
            return
        }

    }

}



