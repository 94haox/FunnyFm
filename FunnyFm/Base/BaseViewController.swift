//
//  BaseViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		self.view.backgroundColor = .systemBackground
		self.view.backgroundColor = R.color.ffWhite()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationItem.largeTitleDisplayMode = .always
		let image = UIImage.init(systemName: "chevron.left.square.fill")
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self.navigationController, action: #selector(UINavigationController.popViewController(animated:)))
		navigationItem.leftBarButtonItem?.tintColor = R.color.mainRed()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
        Hud.shared.hide()
	}
	

}
