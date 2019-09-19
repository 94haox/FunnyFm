//
//  HistotyProgressBar.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/19.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class HistoryProgressBar: UIView {
	
	var progress: Double = 0
	
	let progressView = UIView()
	
	var progressColor = CommonColor.mainRed.color
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setupUI()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	func update(with progress:Double){
		self.progress = progress
		progressView.snp.remakeConstraints { (make) in
			make.left.height.centerY.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(progress)
		}
		
		UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
			self.layoutIfNeeded()
		}, completion: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI()
	}
	
	func setupUI() {
		self.backgroundColor = CommonColor.subtitle.color
		self.cornerRadius = 2
		self.progressView.backgroundColor = self.progressColor
		self.addSubview(progressView)
		progressView.snp.makeConstraints { (make) in
			make.left.height.centerY.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(progress)
		}
	}
	
}
