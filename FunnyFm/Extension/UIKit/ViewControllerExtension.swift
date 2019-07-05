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
}
