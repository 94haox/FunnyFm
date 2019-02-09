//
//  AppDelegate.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    var options: [UIApplication.LaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.options = launchOptions
		FMPlayerManager.shared.delegate = FMToolBar.shared
        configureNavigationTabBar()
        DatabaseManager.setupDefaultDatabase()
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCenter.default.addObserver(self, selector: #selector(setUpPush), name: NSNotification.Name.init("firstSetUpPush"), object: nil)

        MSAppCenter.start("f9778dd8-1385-462e-a4e1-fa37182cb200", withServices:[MSAnalytics.self,MSCrashes.self])
        return true
    }
    
    
    @objc func setUpPush(){
        jspushConfig(launchOptions: self.options)
    }
    
    
    func jspushConfig(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)  {
        let entity = JPUSHRegisterEntity.init()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue|JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
        } else {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue)
        }

        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: JPushConfig.shared())
        JPUSHService.setup(withOption: launchOptions, appKey: FunnyFm.jpushAppKey, channel: "app store", apsForProduction: false)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if (event?.type == .remoteControl) {
            var order = -1
            switch ((event?.subtype)!) {
            case .remoteControlPause:
                order = 0;
                break;
            case .remoteControlPlay:
                order = 1;
                break;
            default:
                break;
            }
            NotificationCenter.default.post(name: NSNotification.Name.init("FMREMOTECONTROLNOTIFICATION"), object: nil, userInfo: ["action":String(order)])
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        configPlayBackgroungMode()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let key = url.absoluteString.components(separatedBy: "=").last{
            print("jek---",key)
            return true
        }
        return false
    }


}

