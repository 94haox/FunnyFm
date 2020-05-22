//
//  WelcomeViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/16.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SwiftUI

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
    
    @IBAction func showPolicy(_ sender: Any) {
        let termView = PolicyView() // swiftUIView is View
        let viewCtrl = UIHostingController(rootView: termView)
		self.presentAsStork(viewCtrl, height: kScreenHeight/2.0)
    }
    
    @IBAction func showTerm(_ sender: Any) {
        let termView = TermView() // swiftUIView is View
        let viewCtrl = UIHostingController(rootView: termView)
        self.present(viewCtrl, animated: true, completion: nil)
    }
}
