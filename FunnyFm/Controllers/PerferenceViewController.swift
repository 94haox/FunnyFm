//
//  PerferenceViewController.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/5/29.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class PerferenceViewController: UIViewController {

	@IBOutlet weak var autoSkipSection: UILabel!
	
	@IBOutlet weak var skipDurationLB: UILabel!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .clear
		let sliderFrame = CGRect(x: self.autoSkipSection.frame.minX, y: 0, width: view.bounds.width * 0.7, height: 30)
		let slider = JellySlider(frame: sliderFrame)
		slider.onValueChange = { value in
			self.skipDurationLB.text = "\(Int(value * 180)) sec"
		}
		slider.trackColor = R.color.mainRed()!
        slider.sizeToFit()
		self.view.addSubview(slider)
    }

}

