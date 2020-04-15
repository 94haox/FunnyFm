//
//  BaseTabBarViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/29.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class BaseTabBarViewController: AnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		FMPlayerManager.shared.delegate = FMToolBar.shared
        AppDelegate.current.window.addSubview(FMToolBar.shared)
        FMToolBar.shared.isHidden = true
		PlayListManager.shared.updatePlayQueue()
		if PlayListManager.shared.playQueue.first.isSome {
			FMToolBar.shared.configAtStart(episode: PlayListManager.shared.playQueue.first!)
		}
		
    }
	
	override func viewSafeAreaInsetsDidChange() {
		super.viewSafeAreaInsetsDidChange()
		FMToolBar.shared.bottomInset = self.view.safeAreaInsets.bottom
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppDelegate.current.window.bringSubviewToFront(FMToolBar.shared)
		FMToolBar.shared.explain()
	}
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidAppear(animated)
		FMToolBar.shared.shrink()
	}
	
}
