//
//  EmptyMainViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/3.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Lottie

class EmptyMainViewController: UIViewController {

	@IBOutlet weak var welcomeTopConst: NSLayoutConstraint!
	@IBOutlet weak var musicTopConst: NSLayoutConstraint!
	@IBOutlet weak var welcomeLB: UILabel!
	@IBOutlet weak var welImgView: UIImageView!
	
	var firework : AnimationView = {
		let view = AnimationView.init(name: "boom")
		return view
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CommonColor.white.color
		welcomeTopConst.constant = 50.adapt()
		musicTopConst.constant = 100.adapt()
		welImgView.snp_makeConstraints { (make) in
			make.height.equalTo(260.adapt())
		}
		self.view.addSubview(self.firework)
		self.firework.snp.makeConstraints { (make) in
			make.center.equalTo(self.welcomeLB)
			make.size.equalTo(CGSize.init(width: kScreenWidth, height: kScreenHeight))
		}
		self.firework.play()
		self.navigationController?.sh_fullscreenPopGestureRecognizer.isEnabled = false
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.sh_fullscreenPopGestureRecognizer.isEnabled = true
 	}

	@IBAction func toSeatchVC(_ sender: Any) {
		let search = SearchViewController.init()
		self.navigationController?.pushViewController(search);
		self.navigationController?.viewControllers .remove(at: 1)
	}
	
	@IBAction func toLoginVC(_ sender: Any) {
        guard VipManager.shared.isVip else {
            self.alertVip()
            return
        }
		self.navigationController?.popViewController()
		NotificationCenter.default.post(name: Notification.needLoginNotification, object: nil)
	}

}
