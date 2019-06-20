//
//  AppDelegate.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterDistribute
import AppCenterAnalytics
import AppCenterCrashes
import SPStorkController
import OfficeUIFabric


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    var options: [UIApplication.LaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow.init()
        self.options = launchOptions
		FMPlayerManager.shared.delegate = FMToolBar.shared
        configureNavigationTabBar()
		configureTextfield()
        DatabaseManager.setupDefaultDatabase()
        UIApplication.shared.applicationIconBadgeNumber = 0
        MSAppCenter.start("f9778dd8-1385-462e-a4e1-fa37182cb200", withServices:[MSAnalytics.self,MSCrashes.self])
		
		let navi = UINavigationController.init(rootViewController: MainViewController.init())
		navi.navigationBar.isHidden = true
		self.window?.rootViewController = navi
		self.window?.makeKeyAndVisible()
        return true
    }
	
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
    }
	
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
        FMPlayerManager.shared.pause()
    }
    
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



