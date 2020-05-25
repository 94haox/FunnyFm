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
		DatabaseManager.setupDefaultDatabase()
        VipManager.shared.completeTransactions()
        DownloadManager.shared.configSession();
		FirebaseApp.configure()
		Bugly.start(withAppId: "fe63efca9b")
		self.dw_addNotifies()
        configureNavigationTabBar()
		configureTextfield()
		VersionManager.setupSiren()
        self.window.rootViewController = self.configRootVC()
		self.window.makeKeyAndVisible()
        return true
    }
	
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
		FMToolBar.shared.toobarPause()
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


// MARK: - Notifications
extension AppDelegate {
    	
	func dw_addNotifies(){
		NotificationCenter.default.addObserver(self, selector: #selector(setupJpush), name: Notification.setupNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toLoginVC), name: Notification.needLoginNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(toMainVC), name: Notification.toMainNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(episodeUpdate(noti:)), name: Notification.podcastUpdateNewEpisode, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(appUpdate), name: Notification.appHasNewVersionReleased, object: nil)

	}
	
	@objc func toLoginVC(){
		DispatchQueue.main.async {
			let loginNavi = UINavigationController.init(rootViewController: AppleLoginTypeViewController.init())
            loginNavi.navigationBar.isHidden = true
            self.window.rootViewController!.present(loginNavi, animated: true, completion: nil)
		}
	}
	
	@objc func toMainVC(){
		DispatchQueue.main.async {
            self.window.rootViewController = ClientConfig.shared.rootController()
		}
	}
	
	@objc func episodeUpdate(noti: Notification){
		if noti.userInfo.isSome {
			let feedurl = noti.userInfo!["feedurl"] as! String
			let pod = DatabaseManager.getPodcast(feedUrl: feedurl)
			if pod.isNone {
				return
			}
			let vc = PodDetailViewController.init(pod: pod!)
			let navi = self.window.rootViewController as! UINavigationController
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
				let navi = self.window.rootViewController as! UINavigationController
				navi.pushViewController(vc)
			}
			return true
		}
		
		return false
	}
	
	
	func applicationDidBecomeActive(_ application: UIApplication) {
	}
}

extension AppDelegate: JPUSHRegisterDelegate {
	
	@objc func setupJpush(){
        UserDefaults.standard.set(true, forKey: ff_isConfigANPS)
		let entity = JPUSHRegisterEntity.init()
		entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue | JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
		JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
		JPUSHService.setup(withOption: self.options, appKey: "96982e6dbcb84da30216bdb1", channel: "app store", apsForProduction: true)
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		JPUSHService.registerDeviceToken(deviceToken)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		JPUSHService.handleRemoteNotification(userInfo)
		completionHandler(UIBackgroundFetchResult.newData)
	}

	func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
		
	}

	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
		completionHandler(Int(UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.alert.rawValue));
	}
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
		let userinfo = response.notification.request.content.userInfo
		if let trigger = response.notification.request.trigger {
			if trigger.isKind(of: UNPushNotificationTrigger.self) {
				JPUSHService.handleRemoteNotification(userinfo)
				PushManager.shared.handlerNotification(userInfo: userinfo)
			}
		}
		completionHandler()
	}
	
	func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
		
	}
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        restorationHandler([FMToolBar.shared])
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {

        if DownloadManager.shared.sessionManager.identifier == identifier {
            DownloadManager.shared.sessionManager.completionHandler = completionHandler
        }
    }
	
	
}




