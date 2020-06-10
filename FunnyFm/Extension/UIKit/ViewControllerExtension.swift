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
	
	func curveTopCorners() {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 30, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
	
}


extension UIViewController : SPStorkControllerDelegate {

	public func didDismissStorkByTap() {
		self.viewWillAppear(true)
	}
	
	public func didDismissStorkBySwipe() {
		self.viewWillAppear(true)
	}
	
}
