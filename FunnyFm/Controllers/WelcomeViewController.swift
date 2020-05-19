//
//  WelcomeViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/16.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var policyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

	@IBAction func toMainVCAction(_ sender: Any) {
        if !policyBtn.isSelected {
            return
        }
        self.navigationController?.pushViewController(PrivacyViewController())
	}
    
    @IBAction func checkPolicy(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func showPolicyAndTerm(_ sender: Any) {
        
    }
}
