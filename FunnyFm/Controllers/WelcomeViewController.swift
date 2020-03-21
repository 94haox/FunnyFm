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
		NotificationCenter.default.post(name: NSNotification.Name.init(kToMainAction), object: nil)
	}
    
    @IBAction func setUpNotiAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.setupNotification, object: nil)
        //TODO 延迟两秒，检查授权
        
    }
}
