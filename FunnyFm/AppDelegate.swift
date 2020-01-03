//
//  AppDelegate.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import OfficeUIFabric
import OneSignal
//import GoogleMobileAds
import Firebase
import FirebaseUI
import AnimatedTabBar
import Siren

@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate{
	
	var items = [AnimatedTabBarItem(icon: UIImage(named: "thunder") ?? UIImage(),
					   title: "New", controller: MainViewController()),
	AnimatedTabBarItem(icon: UIImage(named: "rss_tab") ?? UIImage(),
	title: "Discover", controller: DiscoveryViewController()),
	AnimatedTabBarItem(icon: UIImage(named: "playlist") ?? UIImage(),
					   title: "Playlist", controller: PlayListViewController()),
	AnimatedTabBarItem(icon: UIImage(named: "usercenter") ?? UIImage(),
					   title: "User", controller: UserCenterViewController())]
	
    var window: UIWindow?
    
    var options: [UIApplication.LaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		self.dw_addNotifies()
		self.window = UIWindow.init()
        self.options = launchOptions
        configureNavigationTabBar()
		configureTextfield()
        DatabaseManager.setupDefaultDatabase()
		GDTSDKConfig.setSdkSrc("14")
		PushManager().configurePushSDK(launchOptions: launchOptions)
		VersionManager.setupSiren()
		
        UIApplication.shared.applicationIconBadgeNumber = 0

//		var navi = UINavigationController.init(rootViewController: MainViewController.init())
//		navi.navigationBar.isHidden = true
		let controller = BaseTabBarViewController()
        controller.delegate = self
		AnimatedTabBarAppearance.shared.animationDuration = 0.5
		AnimatedTabBarAppearance.shared.dotColor = CommonColor.mainRed.color
		AnimatedTabBarAppearance.shared.textColor = CommonColor.mainRed.color

		var navi = UINavigationController.init(rootViewController:controller)
		navi.navigationBar.isHidden = true
		if !UserDefaults.standard.bool(forKey: "isFirst") {
			navi = UINavigationController.init(rootViewController: WelcomeViewController.init())
			UserDefaults.standard.set(true, forKey: "isFirst")
		}
		self.window?.rootViewController = navi
		self.window?.makeKeyAndVisible()
        return true
    }
	
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
		FMToolBar.shared.toobarPause()
    }
	
}

// MARK: - Notifications
extension AppDelegate {
	
	func dw_addNotifies(){
//		NotificationCenter.default.addObserver(self, selector: #selector(setupNotification), name: Notification.setupNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toLoginVC), name: Notification.needLoginNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toMainVC), name: Notification.toMainNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(episodeUpdate(noti:)), name: Notification.podcastUpdateNewEpisode, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(appUpdate), name: Notification.appHasNewVersionReleased, object: nil)

	}
	
	@objc func toLoginVC(){
		DispatchQueue.main.async {
			let navi = self.window?.rootViewController as! UINavigationController
			if #available(iOS 13.0, *) {
				let loginNavi = UINavigationController.init(rootViewController: AppleLoginTypeViewController.init())
				loginNavi.navigationBar.isHidden = true
				navi.present(loginNavi, animated: true, completion: nil)
				return
			}
			let loginNavi = UINavigationController.init(rootViewController: LoginTypeViewController.init())
			navi.present(loginNavi, animated: true, completion: nil)
		}
	}
	
	@objc func toMainVC(){
		DispatchQueue.main.async {
			let controller = BaseTabBarViewController()
			controller.delegate = self
			AnimatedTabBarAppearance.shared.animationDuration = 0.5
			AnimatedTabBarAppearance.shared.dotColor = CommonColor.mainRed.color
			AnimatedTabBarAppearance.shared.textColor = CommonColor.mainRed.color

			var navi = UINavigationController.init(rootViewController:controller)
			navi.navigationBar.isHidden = true
			self.window?.rootViewController = navi
		}
	}
	
	@objc func episodeUpdate(noti: Notification){
		if noti.userInfo.isSome {
			let podId = noti.userInfo!["podId"] as! String
			let pod = DatabaseManager.getPodcast(podId: podId)
			if pod.isNone {
				return
			}
			let vc = PodDetailViewController.init(pod: pod!)
			let navi = self.window?.rootViewController as! UINavigationController
			navi.pushViewController(vc)
		}
	}
	
	@objc func appUpdate(){
		let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1447922692")!
		UIApplication.shared.openURL(url)
	}
	
}

extension AppDelegate : ViewModelDelegate {
	
	func viewModelDidGetDataSuccess() {
		MSHUD.shared.hide()
		let preview = PodPreviewViewController()
		preview.modalPresentationStyle = .overCurrentContext
		let vc = self.window!.rootViewController!
		let transitionDelegate = SPStorkTransitioningDelegate()
		transitionDelegate.customHeight = 450;
		preview.transitioningDelegate = transitionDelegate
		preview.modalPresentationStyle = .custom
		preview.modalPresentationCapturesStatusBarAppearance = true
		vc.present(preview, animated: true, completion: nil)
		preview.config(pod: GlobalViewModel.shared.importPod!)
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		MSHUD.shared.showFailure(in: self.window!, with: msg!)
	}
}


// MARK: - itunes 分享
extension AppDelegate {
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
		print(url.absoluteString)
		
		let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
		if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
			return true
		}
		let urlString = url.absoluteString
		if urlString.hasPrefix("funnyfm://podcast") {
			let params = urlString.components(separatedBy: "=")
			if params.count > 0{
				let podId = params.last!
				let pod = DatabaseManager.getPodcast(podId: podId)
				if pod.isNone {
					return false
				}
				let vc = PodDetailViewController.init(pod: pod!)
				let navi = self.window?.rootViewController as! UINavigationController
				navi.pushViewController(vc)
			}
			return true
		}
		
		return false
	}
	
	
	func applicationDidBecomeActive(_ application: UIApplication) {
	}
}


extension AppDelegate : AnimatedTabBarDelegate {
	
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



