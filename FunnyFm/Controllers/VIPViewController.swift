//
//  VIPViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class VIPViewController: BaseViewController {
	
	var resumeBtn: UIButton = UIButton.init(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "订购 Pro".localized
    }

    
}

//MARK: Actions
extension VIPViewController {
	
}

//MARK: UI
extension VIPViewController {
	
	func dw_addConstraints(){
		
	}
	
	func setupUI(){
		self.resumeBtn.setTitleForAllStates("恢复购买")
		self.resumeBtn.setTitleColorForAllStates(CommonColor.mainRed.color)
	}
	
}
