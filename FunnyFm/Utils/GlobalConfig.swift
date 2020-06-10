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
	let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithTransparentBackground()
    navBarAppearance.backgroundColor = R.color.ffWhite()
	navBarAppearance.shadowImage = UIImage()
    navBarAppearance.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: CommonColor.title.color,
		NSAttributedString.Key.font: p_bfont(14)
    ]
	navBarAppearance.largeTitleTextAttributes = [
		 NSAttributedString.Key.foregroundColor: CommonColor.title.color,
		 NSAttributedString.Key.font: p_bfont(subtitleFontSize)
	]
	UINavigationBar.appearance().tintColor = R.color.ffWhite()
	UINavigationBar.appearance().isTranslucent = false
	UINavigationBar.appearance().shadowImage = UIImage()
	UINavigationBar.appearance().standardAppearance = navBarAppearance
	UINavigationBar.appearance().compactAppearance = navBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
	
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
