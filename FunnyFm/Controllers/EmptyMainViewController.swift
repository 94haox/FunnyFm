//
//  EmptyMainViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/3.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import pop

class EmptyMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}

	@IBAction func toSeatchVC(_ sender: Any) {
		let search = SearchViewController.init()
		self.navigationController?.pushViewController(search);
		self.navigationController?.viewControllers .remove(at: 1)
	}
	
	@IBAction func toLoginVC(_ sender: Any) {
		let login = NeLoginViewController()
		self.navigationController?.pushViewController(login)
		self.navigationController?.viewControllers .remove(at: 1)
	}

}
