//
//  BaseTabBarViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/29.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SwiftUI

struct BaseTabbarView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BaseTabBarViewController {
        return BaseTabBarViewController()
    }
    
    func updateUIViewController(_ uiViewController: BaseTabBarViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = BaseTabBarViewController
    
    
}


class BaseTabBarViewController: AnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		FMPlayerManager.shared.delegate = FMToolBar.shared
		self.view.addSubview(FMToolBar.shared)
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
        UIView.animate(withDuration: 0.3) {
			FMToolBar.shared.alpha = 1
            var frame = self.tabBar.frame;
            frame.origin = CGPoint.init(x: 0, y: frame.origin.y - frame.size.height);
            self.tabBar.frame = frame;
        }
	}
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidAppear(animated)
		FMToolBar.shared.shrink()
		FMToolBar.shared.alpha = 0
        UIView.animate(withDuration: 0.3) {
            var frame = self.tabBar.frame;
            frame.origin = CGPoint.init(x: 0, y: frame.size.height + frame.origin.y);
            self.tabBar.frame = frame;
        }
	}
	
}
