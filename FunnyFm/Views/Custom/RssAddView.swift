//
//  RssAddView.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/31.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit




class RssAddView: UIView {

    private let addBtn: UIButton = UIButton.init(type: .custom)
	private let inputTextField: FMTextField = FMTextField.init()
	var searchBlock: ((String)->Void)?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension RssAddView {
	
	@objc func addAction(){
		self.addBtn.isSelected = !self.addBtn.isSelected
		if self.addBtn.isSelected {
			self.inputTextField.becomeFirstResponder()
			self.addBtn.snp.remakeConstraints { (make) in
				make.right.equalToSuperview()
				make.centerY.equalToSuperview()
				make.width.equalTo(60)
				make.height.equalToSuperview()
			}
		}else{
			self.endEditing(true)
			self.addBtn.snp.remakeConstraints { (make) in
				make.center.equalToSuperview()
				make.width.equalToSuperview().offset(-10.auto())
				make.height.equalToSuperview()
			}
		}
		
		UIView.animate(withDuration: 0.2) {
			self.layoutIfNeeded()
		}
	}
	
}

extension RssAddView: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.text.isSome && textField.text!.length() > 5 {
			if self.searchBlock.isSome {
				self.searchBlock!(textField.text!)
			}
		}else{
			SwiftNotice.showText("请输入完整订阅地址")
		}
		return true
	}
}

extension RssAddView {
	
	func setupUI(){
		self.addBtn.setImage(UIImage.init(named: "rss_white"), for: .normal)
		self.addBtn.setTitle("通过 RSS 链接订阅播客", for: .normal)
		self.addBtn.setImage(nil, for: .normal)
		self.addBtn.setTitle("取消", for: .selected)
		self.addBtn.setTitleColorForAllStates(.white)
		self.addBtn.titleLabel?.font = p_bfont(fontsize3)
		self.addBtn.cornerRadius = 5
		self.addBtn.backgroundColor = CommonColor.mainRed.color
		self.addBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 30.auto())
		self.addBtn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
		
		self.inputTextField.attributedPlaceholder = FunnyFm.attributePlaceholder("输入 RSS 链接")
		self.inputTextField.tintColor = CommonColor.mainRed.color
		self.inputTextField.delegate = self
		self.inputTextField.borderColor = CommonColor.mainRed.color
		self.inputTextField.borderWidth = 0.5
		self.inputTextField.cornerRadius = 5
		self.inputTextField.textColor = CommonColor.content.color
		self.inputTextField.font = pfont(12)
		self.inputTextField.returnKeyType = .done
		
		self.addSubview(self.inputTextField)
		self.addSubview(self.addBtn)
		
		self.addBtn.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.width.equalToSuperview().offset(-10.auto())
			make.height.equalToSuperview()
		}
		
		self.inputTextField.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.width.equalToSuperview().offset(-75.auto())
			make.left.equalToSuperview().offset(5.auto())
			make.height.equalToSuperview()
		}
		
	}
	
}
