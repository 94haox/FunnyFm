//
//  ProgressHUD.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/27.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class ProgressHUD: UIView {
	
	lazy var titleLB: UILabel = {
		let label = UILabel.init()
		label.font = p_bfont(10)
		label.textColor = UIColor.white
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.alpha = 0
		self.layer.cornerRadius = 5
		self.backgroundColor = CommonColor.mainRed.color
		self.addSubview(self.titleLB)
		self.titleLB.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func show(title:String){
		self.titleLB.text = title
		if self.alpha == 1 {
			return
		}
		UIView.animate(withDuration: 0.2, animations: {
			self.alpha = 1
		}) { (isComplete) in
			
		}
	}
	
	func hide(){
		UIView.animate(withDuration: 0.2) {
			self.alpha = 0
		}
	}

}
