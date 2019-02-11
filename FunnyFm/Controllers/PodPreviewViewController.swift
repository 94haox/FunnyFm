//
//  PodPreviewViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/2/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SnapKit

class PodPreviewViewController: BaseViewController {
	
	@IBOutlet weak var podImageView: UIImageView!
	@IBOutlet weak var centerView: UIView!
	@IBOutlet weak var podNameLB: UILabel!
	@IBOutlet weak var desLB: UILabel!
	@IBOutlet weak var subscribeBtn: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = RGBA(0, 0, 0, 0.1)
		self.view.addSubview(self.closeBtn)
		self.closeBtn.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.view.snp_rightMargin).offset(-30+12)
			make.centerY.equalTo(self.view).offset(-90+5)
			make.size.equalTo(CGSize.init(width: 24, height: 24))
		}
        // Do any additional setup after loading the view.
    }
	

	lazy var closeBtn: UIButton = {
		let btn = UIButton.init(type: .custom)
		btn.setImage(UIImage.init(named: "close"), for: .normal)
		btn.backgroundColor = .white
		btn.cornerRadius = 12
		btn.borderColor = CommonColor.mainRed.color
		btn.borderWidth = 3
		btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
		return btn
	}()
	
	@objc func closeAction() {
		self.dismiss(animated: false, completion: nil)
	}

}
