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
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    var options: [UIApplication.LaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		MSAppCenter.start("f9778dd8-1385-462e-a4e1-fa37182cb200", withServices:[MSAnalytics.self,MSCrashes.self])
		self.dw_addNotifies()
		self.window = UIWindow.init()
        self.options = launchOptions
		FMPlayerManager.shared.delegate = FMToolBar.shared
        configureNavigationTabBar()
		configureTextfield()
        DatabaseManager.setupDefaultDatabase()
        UIApplication.shared.applicationIconBadgeNumber = 0
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
		NotificationCenter.default.addObserver(self, selector: #selector(setUpNotification), name: NSNotification.Name.init(kSetupNotification), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toLoginVC), name: NSNotification.Name.init(kNeedLoginAction), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toMainVC), name: NSNotification.Name.init(kToMainAction), object: nil)

	}
	
	@objc func setUpNotification() {
		PushManager().configurePushSDK(launchOptions: self.options)
	}
	
	@objc func toLoginVC(){
		let navi = self.window?.rootViewController as! UINavigationController
		navi.pushViewController(NeLoginViewController.init())
	}
	
	@objc func toMainVC(){
		let navi = UINavigationController.init(rootViewController: MainViewController.init())
		navi.navigationBar.isHidden = true
		self.window?.rootViewController = navi
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
		preview.configWithPod(pod: GlobalViewModel.shared.importPod!)
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		MSHUD.shared.showFailure(in: self.window!, with: msg!)
	}
}


// MARK: - itunes 分享
extension AppDelegate {
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
		print(url.absoluteString)
		if url.absoluteString.hasPrefix("funnyfm://itunsUrl=https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPodcast") {
			if let key = url.absoluteString.components(separatedBy: "?").last{
				if let id = key.components(separatedBy: "#").first{
					let podid = id.subString(from: 3)
					print("podId------",podid)
					GlobalViewModel.shared.delegate = self;
					GlobalViewModel.shared.getPrePodFromItuns(podId: podid, source: "iTunes")
				}
				return true
			}
		}
		if let key = url.absoluteString.components(separatedBy: "?").first{
			if let id = key.components(separatedBy: "/").last{
				let podid = id.subString(from: 2)
				print("podId------",podid)
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



