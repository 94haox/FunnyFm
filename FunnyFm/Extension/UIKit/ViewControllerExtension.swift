//
//  ViewControllerExtension.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/5.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import UIKit
import SPStorkController

extension UIViewController {
	
	func dw_addTouchEndEdit(){
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEidted))
		self.view.addGestureRecognizer(tap)
	}
	
	@objc func endEidted(){
		self.view.endEditing(true)
	}
	
	func dw_presentAsStork(controller: UIViewController, heigth: CGFloat, delegate: UIViewController?){
		let transitionDelegate = SPStorkTransitioningDelegate()
		transitionDelegate.storkDelegate = delegate
		transitionDelegate.customHeight = heigth
//		transitionDelegate.confirmDelegate = controller as? SPStorkControllerConfirmDelegate
		controller.transitioningDelegate = transitionDelegate
		controller.modalPresentationStyle = .custom
		
		self.present(controller, animated: true, completion: nil)
	}
	
}


extension UIViewController : SPStorkControllerDelegate {

	public func didDismissStorkByTap() {
		let navi = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
		if navi.viewControllers.count < 2  {
			FMToolBar.shared.explain()
		}else{
			FMToolBar.shared.shrink()
		}
		self.viewWillAppear(true)
	}
	
	public func didDismissStorkBySwipe() {
		let navi = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
		if navi.viewControllers.count < 2  {
			FMToolBar.shared.explain()
		}else{
			FMToolBar.shared.shrink()
		}
		self.viewWillAppear(true)
	}
	
}
