//
//  DWSegment.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class DWSegment: UIControl {
	private var squareView: UIView = UIView.init()
	
	private var contaniner: UIView = UIView.init()
	
	private let leftBtn: UIButton = UIButton.init(type: .custom)
	
	private let rightBtn: UIButton = UIButton.init(type: .custom)
	
	var hPadding: Int = 5
	
	var containerCornerRadius: CGFloat = 5
	
	var isOn: Bool = false
	
	var selectColor: UIColor = CommonColor.mainRed.color
	
	convenience init() {
		self.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
		self.toLeft()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	func config(titles:[String]){
		self.leftBtn.setTitle(titles.first!, for: .normal)
		self.rightBtn.setTitle(titles.last!, for: .normal)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - actions
extension DWSegment {
	
	@objc func selectBtn(btn: UIButton) {
		ImpactManager.impact()
		if btn.isSelected {return}
		self.isOn = !self.isOn
		sendActions(for: .valueChanged)
		if btn == self.leftBtn{
			self.toLeft()
		}else if btn == self.rightBtn{
			self.toRight()
		}
	}
}

// MARK: - animations
extension DWSegment {
	
	func toLeft(){

		self.squareView.snp.remakeConstraints { (make) in
			make.left.equalToSuperview().offset(hPadding)
			make.right.equalTo(self.contaniner.snp.centerX).offset(-hPadding)
			make.centerY.equalToSuperview()
			make.height.equalToSuperview().offset(-hPadding * 2)
		}
		
		self.rightBtn.isSelected = false

		UIView.animate(withDuration: 0.2, animations: {
			self.layoutIfNeeded()
		}) { (complete) in
			self.leftBtn.isSelected = true
		}
		
	}
	
	func toRight(){
		
		self.squareView.snp.remakeConstraints { (make) in
			make.right.equalToSuperview().offset(-hPadding)
			make.left.equalTo(self.contaniner.snp.centerX).offset(hPadding)
			make.centerY.equalToSuperview()
			make.height.equalToSuperview().offset(-hPadding * 2)
		}
		
		self.rightBtn.isSelected = true
		UIView.animate(withDuration: 0.2, animations: {
			self.layoutIfNeeded()
		}) { (complete) in
			self.leftBtn.isSelected = false
		}
	}
	
}


// MARK: - UI

extension DWSegment {
	
	func setupUI(){
		self.leftBtn.addTarget(self, action: #selector(selectBtn(btn:)), for: .touchUpInside)
		self.rightBtn.addTarget(self, action: #selector(selectBtn(btn:)), for: .touchUpInside)
		self.leftBtn.setTitleColor(CommonColor.subtitle.color, for: .normal)
		self.leftBtn.setTitleColor(.white, for: .selected)
		self.leftBtn.titleLabel?.font = pfont(14)
		self.rightBtn.titleLabel?.font = pfont(14)
		self.rightBtn.setTitleColor(CommonColor.subtitle.color, for: .normal)
		self.rightBtn.setTitleColor(.white, for: .selected)
		self.contaniner.cornerRadius = self.containerCornerRadius
		self.contaniner.backgroundColor = .white
		self.squareView.backgroundColor = CommonColor.mainRed.color
		self.squareView.cornerRadius = self.containerCornerRadius;
		
		self.addSubview(self.contaniner)
		self.contaniner.addSubview(self.squareView)
		self.contaniner.addSubview(self.leftBtn)
		self.contaniner.addSubview(self.rightBtn)
		
		self.contaniner.snp.makeConstraints { (make) in
			make.edges.equalTo(self)
		}
		
		self.squareView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(hPadding)
			make.right.equalTo(self.contaniner.snp.centerX).offset(-hPadding)
			make.centerY.equalToSuperview()
			make.height.equalToSuperview().offset(-hPadding * 2)
		}
		
		self.leftBtn.snp.makeConstraints { (make) in
			make.left.centerY.height.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(0.5)
		}
		
		self.rightBtn.snp.makeConstraints { (make) in
			make.right.centerY.height.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(0.5)
		}
		
	}
	
}

