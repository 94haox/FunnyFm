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
		let sliderFrame = CGRect(x: self.autoSkipSection.frame.minX, y: 0, width: view.bounds.width * 0.8, height: 30)
		let slider = JellySlider(frame: sliderFrame)
		slider.onValueChange = { value in
			self.skipDurationLB.text = "\(Int(value * 180)) sec"
		}
		slider.trackColor = R.color.mainRed()!
        slider.sizeToFit()
		self.view.addSubview(slider)
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

