//
//  AppDelegate.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import SPStorkController
import OfficeUIFabric
import OneSignal
import CleanyModal
import GoogleMobileAds
import Firebase
import FirebaseUI

@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    var options: [UIApplication.LaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		self.dw_addNotifies()
		self.window = UIWindow.init()
        self.options = launchOptions
		FMPlayerManager.shared.delegate = FMToolBar.shared
        configureNavigationTabBar()
		configureTextfield()
        DatabaseManager.setupDefaultDatabase()
		
		PushManager().configurePushSDK(launchOptions: launchOptions)
		
        UIApplication.shared.applicationIconBadgeNumber = 0
		let mainVC = MainViewController()
		mainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage.init(named: "handbag")!, tag: 0)
		
		let downloadVC = DownloadListController()
		downloadVC.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage.init(named: "download")!, tag: 0)
		downloadVC.tabBarItem.selectedImage = UIImage.init(named: "download")!
		
		
		UIApplication.shared.applicationIconBadgeNumber = 0
		let userVC = UserCenterViewController()
		userVC.tabBarItem = UITabBarItem(title: "Center", image: UIImage.init(named: "profile"), tag: 0)
		
		let tabBarController = BubbleTabBarController()
		tabBarController.viewControllers = [mainVC,downloadVC, userVC]
		tabBarController.tabBar.tintColor = CommonColor.mainRed.color
		var navi = UINavigationController.init(rootViewController: MainViewController.init())
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
        FMPlayerManager.shared.pause()
    }
	
}

// MARK: - Notifications
extension AppDelegate {
	
	func dw_addNotifies(){
		NotificationCenter.default.addObserver(self, selector: #selector(setupNotification), name: Notification.setupNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toLoginVC), name: Notification.needLoginNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toMainVC), name: Notification.toMainNotification, object: nil)

	}
	
	@objc func setupNotification() {
		
		UserDefaults.standard.set(true, forKey: "isShowNotifi")
		
		let alertConfig = CleanyAlertConfig(
			title: "Hei Bro.",
			message: "为了及时将播客的更新通知到你，FunnyFM 需要获取手机的推送权限哦".localized)
		let alert = AlertViewController.init(config: alertConfig)
		
		alert.addAction(title: "去设置".localized, style: .default) { (action) in
			self.setUpNotificationAction()
		}
		alert.addAction(title: "不，我不需要".localized, style: .cancel)
		self.window?.rootViewController?.present(alert, animated: true, completion: nil)
	}
	
	func setUpNotificationAction() {
		if !PrivacyManager.isOpenPusn() {
			UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
			return;
		}
		PushManager().configurePushSDK(launchOptions: self.options)
	}
	
	@objc func toLoginVC(){
		DispatchQueue.main.async {
			let navi = self.window?.rootViewController as! UINavigationController
			let loginNavi = UINavigationController.init(rootViewController: LoginTypeViewController.init())
			navi.present(loginNavi, animated: true, completion: nil)
		}
	}
	
	@objc func toMainVC(){
		DispatchQueue.main.async {
			let navi = UINavigationController.init(rootViewController: MainViewController.init())
			navi.navigationBar.isHidden = true
			self.window?.rootViewController = navi
		}
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
		
		if url.absoluteString.hasPrefix("funnyfm://itunsUrl=https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPodcast") {
			if let key = url.absoluteString.components(separatedBy: "?").last{
				if let id = key.components(separatedBy: "#").first{
					let podid = id.subString(from: 3)
					GlobalViewModel.shared.delegate = self;
					GlobalViewModel.shared.getPrePodFromItuns(podId: podid, source: "iTunes")
				}
				return true
			}
		}
		if let key = url.absoluteString.components(separatedBy: "?").first{
			if let id = key.components(separatedBy: "/").last{
				let podid = id.subString(from: 2)
				GlobalViewModel.shared.delegate = self;
				GlobalViewModel.shared.getPrePodFromItuns(podId: podid, source: "iTunes")
				
			}
			return true
		}
		
		SwiftNotice.showText("暂不支持此分享源")
		return false
	}
	
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		if let shareUrl = UIPasteboard.general.string {
			if shareUrl.contains("music.163.com/radio"){
				if let prefix = shareUrl.components(separatedBy: "?").first {
					if let id = prefix.components(separatedBy: "/").last{
						if (UserDefaults.standard.object(forKey: "netease_rid") != nil){
							let rid = UserDefaults.standard.object(forKey: "netease_rid") as! String
							if rid == id {
								return;
							}
						}
						UserDefaults.standard.set(id, forKey: "netease_rid")
						UserDefaults.standard.synchronize()
						MSHUD.shared.show(in: self.window!)
						GlobalViewModel.shared.delegate = self;
						GlobalViewModel.shared.getPrePodFromItuns(podId: id, source: "netease")
					}
				}
			}
		}
	}
}



