//
//  AlertViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class AlertViewController: CleanyAlertViewController {
	
	override init(config: CleanyAlertConfig) {
		config.styleSettings[.tintColor] = CommonColor.mainRed.color
		config.styleSettings[.destructiveColor] = CommonColor.mainRed.color
		super.init(config: config)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.contentStackView.backgroundColor = .white
		
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
