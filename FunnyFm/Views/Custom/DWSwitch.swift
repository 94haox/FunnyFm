//
//  DWSwitch.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SnapKit
import pop
import RxSwift

class DWSwitch: UIControl {
	
	private var graySquare: UIView = UIView.init()
	
	private var contaniner: UIView = UIView.init()
	
	var selectLayer: CAShapeLayer!
	
	var hPadding: Int = 5
	
	var containerCornerRadius: CGFloat = 5
	
	var isOn: Bool = false
	
	var selectColor: UIColor = CommonColor.mainRed.color
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(self.contaniner)
		self.contaniner.cornerRadius = self.containerCornerRadius
		self.contaniner.addSubview(self.graySquare)
		self.contaniner.backgroundColor = .white
		self.graySquare.backgroundColor = CommonColor.background.color
		self.graySquare.cornerRadius = 5;
		
		self.contaniner.snp.makeConstraints { (make) in
			make.width.equalToSuperview()
			make.height.equalToSuperview()
			make.center.equalToSuperview()
		}
		
		self.graySquare.snp.makeConstraints({ (make) in
			make.centerY.equalToSuperview()
			make.height.equalTo(self.contaniner).offset(-hPadding)
			make.width.equalTo(self.contaniner.snp.height).offset(-hPadding)
			make.left.equalTo(self.contaniner).offset(hPadding)
		})
		self.layoutIfNeeded()
//		self.dw_configPathLayer()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
}


// MARK: - square action

extension DWSwitch {
	
	func toLeft(){
		self.contaniner.snp.remakeConstraints { (make) in
			make.width.equalToSuperview()
			make.height.equalToSuperview()
			make.center.equalToSuperview()
		}
		
		self.graySquare.snp.remakeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.height.equalTo(self.contaniner).offset(-hPadding)
			make.width.equalTo(self.contaniner.snp.height).offset(-hPadding)
			make.left.equalTo(self.contaniner).offset(hPadding)
		}
		self.selectLayer.isHidden = true
		UIView.animate(withDuration: 0.2) {
			self.layoutIfNeeded()
			self.graySquare.backgroundColor = CommonColor.background.color
		}
		
	}
	
	func toRight(){
		
		self.contaniner.snp.remakeConstraints { (make) in
			make.width.equalToSuperview()
			make.height.equalToSuperview()
			make.center.equalToSuperview()
		}
		
		self.graySquare.snp.remakeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.height.equalTo(self.contaniner).offset(-hPadding)
			make.width.equalTo(self.contaniner.snp.height).offset(-hPadding)
			make.right.equalTo(self.contaniner).offset(-hPadding)
		}
		
		UIView.animate(withDuration: 0.2, animations: {
			self.layoutIfNeeded()
			self.graySquare.backgroundColor = CommonColor.mainRed.color
		}) { (complete) in
			self.selectLayer.isHidden = false
		}
	}
	
}

// MARK: - UI

extension DWSwitch {
	
	func dw_configPathLayer(){
		let path = UIBezierPath.init(ovalIn: CGRect.init(x: self.graySquare.width/4.0, y: self.graySquare.width/4.0, width: self.graySquare.width/2.0, height: self.graySquare.width/2.0))
//		path.move(to: CGPoint.init(x: self.graySquare.frame.size.width/5.0, y: self.graySquare.frame.size.width/2.0))
//		path.addLine(to: CGPoint.init(x: self.graySquare.frame.size.width/5.0*2, y: self.graySquare.frame.size.width/3.0*2))
//		path.addLine(to: CGPoint.init(x: self.graySquare.frame.size.width/5.0*4, y: self.graySquare.frame.size.width/4.0*1))
		self.selectLayer = CAShapeLayer.init()
		selectLayer.fillColor = UIColor.clear.cgColor
		selectLayer.strokeColor = UIColor.white.cgColor
		selectLayer.lineWidth = 3;
		selectLayer.lineCap = .round
		selectLayer.lineJoin = .round
		selectLayer.path = path.cgPath
		selectLayer.isHidden = true
		self.graySquare.layer.addSublayer(selectLayer)
	}
	
}


// MARK: - touch animation

extension DWSwitch {
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.contaniner.snp.remakeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(0.9)
			make.height.equalToSuperview().multipliedBy(0.9)
			make.center.equalToSuperview()
		}
		UIView.animate(withDuration: 0.2) {
			self.layoutIfNeeded()
		}
		super.touchesBegan(touches, with: event)
	}


	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if self.isOn {
			self.toLeft()
		}else{
			self.toRight()
		}
		self.isOn = !self.isOn
		super.touchesEnded(touches, with: event)
	}
}
