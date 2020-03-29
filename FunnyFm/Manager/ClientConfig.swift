//
//  ClientConfig.swift
//  FunnyFm
//
//  Created by Duke on 2020/2/3.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class ClientConfig: NSObject {
    
    static let shared = ClientConfig()
    
    var isIPad: Bool = UIDevice.current.model == "iPad"
    
    var controllers: [UIViewController] = []
    
    var items = [AnimatedTabBarItem(icon: R.image.main_ipad()!,
                       title: "New", controller: MainViewController()),
                 AnimatedTabBarItem(icon: R.image.rss_ipad()!,
    title: "Discover", controller: DiscoveryViewController()),
                 AnimatedTabBarItem(icon: R.image.playlist()!,
                       title: "Playlist", controller: PlayListViewController()),
                 AnimatedTabBarItem(icon: R.image.user_ipad()!,
                       title: "User", controller: UserCenterViewController())]
    
    
    
    func rootController() -> UIViewController{
        AnimatedTabBarAppearance.shared.animationDuration = 0.5
        AnimatedTabBarAppearance.shared.dotColor = CommonColor.mainRed.color
        AnimatedTabBarAppearance.shared.textColor = CommonColor.mainRed.color
        
        if isIPad {
            return self.rootControllerForIpad()
        }else{
            return self.rootControllerForIphone()
        }
        
    }
    
    func rootControllerForIpad() -> UISplitViewController{
        AnimatedTabBarAppearance.shared.animationDuration = 0.5
        AnimatedTabBarAppearance.shared.dotColor = CommonColor.mainRed.color
        AnimatedTabBarAppearance.shared.textColor = CommonColor.mainRed.color
        AnimatedTabBarAppearance.shared.textFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 12) ?? .boldSystemFont(ofSize: 12)
        
        let mainNavi = UINavigationController.init(rootViewController: MainViewController())
        mainNavi.navigationBar.isHidden = true
        let discoverNavi = UINavigationController.init(rootViewController:DiscoveryViewController())
        discoverNavi.navigationBar.isHidden = true
        let playlistNavi = UINavigationController.init(rootViewController:PlayListViewController())
        playlistNavi.navigationBar.isHidden = true
        let usercenterNavi = UINavigationController.init(rootViewController:UserCenterViewController())
        usercenterNavi.navigationBar.isHidden = true
        self.controllers = [mainNavi, discoverNavi, playlistNavi, usercenterNavi]

        let splitVC = UISplitViewController.init()
        let masterVC = MasterViewController()
        masterVC.delegate = self
        masterVC.clickClosure = { [weak self] index in
            splitVC.viewControllers = [masterVC, self!.controllers[index]]
        }
        splitVC.maximumPrimaryColumnWidth = 100.auto()
        splitVC.viewControllers = [masterVC, controllers.first!]
        splitVC.preferredDisplayMode = .allVisible;
        splitVC.primaryBackgroundStyle = .none
        FMPlayerManager.shared.delegate = FMToolBar.shared
        splitVC.view?.addSubview(FMToolBar.shared)
        FMToolBar.shared.isHidden = true
        FMToolBar.shared.snp.makeConstraints { (make) in
            make.left.width.bottom.equalToSuperview()
            make.height.equalTo(80.auto())
        }
        PlayListManager.shared.updatePlayQueue()
        if PlayListManager.shared.playQueue.first.isSome {
            FMToolBar.shared.configAtStart(episode: PlayListManager.shared.playQueue.first!)
        }
        
        return splitVC
    }
    
    func rootControllerForIphone() -> UINavigationController{
        let controller = BaseTabBarViewController()
        controller.delegate = self
        var navi = UINavigationController.init(rootViewController:controller)
        navi.navigationBar.isHidden = true
        if !UserDefaults.standard.bool(forKey: "isFirst") {
            navi = UINavigationController.init(rootViewController: WelcomeViewController.init())
            navi.navigationBar.isHidden = true
            UserDefaults.standard.set(true, forKey: "isFirst")
        }
        return navi
    }
    
    
    
    
    
    
}

// MARK: iOS
extension ClientConfig: AnimatedTabBarDelegate {
    
    func initialIndex(_ tabBar: AnimatedTabBar) -> Int? {
        return 0
    }
    
    var numberOfItems: Int {
        return items.count
    }
    
    func tabBar(_ tabBar: AnimatedTabBar, itemFor index: Int) -> AnimatedTabBarItem {
        return items[index]
    }
}

extension ClientConfig: VerticalTabBarDelegate {
    func vTabBar(_ tabBar: VerticalTabBar, itemFor index: Int) -> AnimatedTabBarItem {
        return items[index]
    }
    
    func vInitialIndex(_ tabBar: VerticalTabBar) -> Int? {
        return 0
    }
    
    var vNumberOfItems: Int {
        return items.count
    }
    
}




