//
//  ViewControllerExtension.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/5.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	func dw_addTouchEndEdit(){
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEidted))
		self.view.addGestureRecognizer(tap)
	}
	
	@objc func endEidted(){
		self.view.endEditing(true)
	}
	
	func dw_presentAsStork(controller: UIViewController, heigth: CGFloat, delegate: UIViewController?){
        
        if ClientConfig.shared.isIPad {
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.storkDelegate = delegate
        transitionDelegate.customHeight = heigth
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
		
		self.present(controller, animated: true, completion: nil)
	}
	
}


extension UIViewController : SPStorkControllerDelegate {

	public func didDismissStorkByTap() {
        guard !ClientConfig.shared.isIPad else {
            return
        }
		let navi = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
		if navi.viewControllers.count < 2  {
			FMToolBar.shared.explain()
		}else{
			FMToolBar.shared.shrink()
		}
		self.viewWillAppear(true)
	}
	
	public func didDismissStorkBySwipe() {
        guard !ClientConfig.shared.isIPad else {
            return
        }
		let navi = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
		if navi.viewControllers.count < 2  {
			FMToolBar.shared.explain()
		}else{
			FMToolBar.shared.shrink()
		}
		self.viewWillAppear(true)
	}
	
}
