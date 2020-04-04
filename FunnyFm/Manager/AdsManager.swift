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
    
    var expressAdViews: [GDTNativeExpressAdView] = [GDTNativeExpressAdView]()
    
    private var nativeExpressAd:GDTNativeExpressAd!
        
    func loadAds(viewController: MainViewController) {
        guard !VipManager.shared.isVip else {
            return
        }
        self.targetVc = viewController
        nativeExpressAd = GDTNativeExpressAd.init(appId: "1109760306", placementId: "1070387275054540", adSize: CGSize(width: 30, height: 30))
        nativeExpressAd.delegate = self
        nativeExpressAd.videoAutoPlayOnWWAN = true
        nativeExpressAd.videoMuted = true
        nativeExpressAd.load(loadAccount)
    }

}


extension AdsManager: GDTNativeExpressAdDelegete {

    func nativeExpressAdSuccess(toLoad nativeExpressAd: GDTNativeExpressAd!, views: [GDTNativeExpressAdView]!) {
        expressAdViews = Array.init(views)
        if expressAdViews.count > 0 {
            for obj in expressAdViews {
                let expressView: GDTNativeExpressAdView = obj
                expressView.controller = self.targetVc
                expressView.render()
            }
        }
        self.targetVc?.reloadData()
    }

    func nativeExpressAdFail(toLoad nativeExpressAd: GDTNativeExpressAd!, error: Error!) {
        print("Express Ad Load Fail : \(error.localizedDescription)")
    }

    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        print(#function)
    }
    
    func nativeExpressAdViewClosed(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        self.expressAdViews.removeAll { (ads) -> Bool in
            return ads == nativeExpressAdView
        }
        self.targetVc?.reloadData()
    }


}

