//
//  AppDelegate.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import Siren
import Bugly
import WidgetKit



@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate{
    
    static var current: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    let window = UIWindow(frame: UIScreen.main.bounds)
    
    var options: [UIApplication.LaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		UIApplication.shared.applicationIconBadgeNumber = 0
        self.options = launchOptions
		FunnyFm.startReach()
		DatabaseManager.setupDefaultDatabase()
        VipManager.shared.completeTransactions()
        DownloadManager.shared.configSession();
		FirebaseApp.configure()
		Bugly.start(withAppId: "fe63efca9b")
		self.dw_addNotifies()
        configureNavigationTabBar()
		configureTextfield()
		VersionManager.setupSiren()
		
//		MoPub.sharedInstance().clearCachedNetworks()
//		let config = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "513cebe42e774a029dab367069ab52e2")
//		config.globalMediationSettings = []
//		config.loggingLevel = .info
//		MoPub.sharedInstance().initializeSdk(with: config){
//			print("SDK initialization complete")
//		}
		
        self.window.rootViewController = self.configRootVC()
		self.window.makeKeyAndVisible()
        return true
    }
	
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
		FMToolBar.shared.toobarPause()
		WidgetCenter.shared.reloadAllTimelines()
    }
	
	func configRootVC() -> UIViewController{
        return ClientConfig.shared.rootController()
	}
	
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if ClientConfig.shared.isIPad {
            return .landscapeRight
        }
        return .portrait
    }
    
}

extension AppDelegate : ViewModelDelegate {
	
	func viewModelDidGetDataSuccess() {
		Hud.shared.hide()
		let preview = PodPreviewViewController()
		preview.modalPresentationStyle = .overCurrentContext
		let vc = self.window.rootViewController!
		let transitionDelegate = SPStorkTransitioningDelegate()
		transitionDelegate.customHeight = 450;
		preview.transitioningDelegate = transitionDelegate
		preview.modalPresentationStyle = .custom
		preview.modalPresentationCapturesStatusBarAppearance = true
		vc.present(preview, animated: true, completion: nil)
		preview.config(pod: GlobalViewModel.shared.importPod!)
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
        showAutoHiddenHud(style: .error, text: msg!)
	}
}


// MARK: - itunes 分享
extension AppDelegate {
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
		print(url.absoluteString)
		
		let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
		
		if url.absoluteString == "funnyfm://open/now" {
			if FMPlayerManager.shared.currentModel.isNone {
				return false
			}
			FMToolBar.shared.toPlayDetailView()
			return true
		}
		
		if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
			return true
		}
		
		if ImportManager.handler(url: url) {
			return true
		}
		
		return false
	}
	
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		DownloadManager.shared.resumeAllTask()
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		WidgetCenter.shared.reloadAllTimelines()
	}
	
	func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
		WidgetCenter.shared.reloadAllTimelines()
	}
	

	
}




