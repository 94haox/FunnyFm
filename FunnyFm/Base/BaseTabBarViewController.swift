//
//  BaseTabBarViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/29.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import AnimatedTabBar

class BaseTabBarViewController: AnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		FMPlayerManager.shared.delegate = FMToolBar.shared
		UIApplication.shared.keyWindow?.addSubview(FMToolBar.shared)
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
		UIApplication.shared.keyWindow?.bringSubviewToFront(FMToolBar.shared)
		FMToolBar.shared.explain()
	}
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidAppear(animated)
		FMToolBar.shared.shrink()
	}
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
