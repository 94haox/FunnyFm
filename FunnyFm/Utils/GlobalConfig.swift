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
    UINavigationBar.appearance().titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: CommonColor.title.color,
		NSAttributedString.Key.font: p_bfont(14)
    ]
	UINavigationBar.appearance().largeTitleTextAttributes = [
		 NSAttributedString.Key.foregroundColor: CommonColor.title.color
	]
}

public func configureTextfield(){
	UITextField.appearance().tintColor = R.color.mainRed()!
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
