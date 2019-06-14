//
//  GlobalConfig.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import SHFullscreenPopGestureSwift


public func configureNavigationTabBar() {
	SHFullscreenPopGesture.configure()
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = true
    UINavigationBar.appearance().titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: CommonColor.title.color,
		NSAttributedString.Key.font: p_bfont(14)
    ]
}

public func configureTextfield(){
	UITextField.appearance().tintColor = CommonColor.mainRed.color
}

public func configPlayBackgroungMode(){
	let session = AVAudioSession.sharedInstance()
	do {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        try session.setCategory(.playback, mode: .default, options: .allowAirPlay)
        try session.setActive(true)
	} catch {
		print(error)
	}
}
