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

public func configPlayBackgroungMode(){
	let session = AVAudioSession.sharedInstance()
	do {
		try session.setActive(true)
		try session.setCategory(.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.allowAirPlay)
	} catch {
		print(error)
	}
}
