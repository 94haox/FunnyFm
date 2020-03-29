//
//  WelcomeViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/16.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

	@IBAction func toMainVCAction(_ sender: Any) {
        self.navigationController?.pushViewController(PrivacyViewController())
	}
    
}
