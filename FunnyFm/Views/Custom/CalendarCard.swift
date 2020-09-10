//
//  CalendarCard.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class CalendarCard: UIView {

	private var monthLB: UILabel = {
		let lb = UILabel()
		lb.font = pfont(fontsize0)
		lb.textColor = R.color.subtitle()
		return lb
	}()
	
	private var dayLB: UILabel = {
		let lb = UILabel()
		lb.font = p_bfont(fontsize6)
		lb.textColor = R.color.titleColor()
		return lb
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		config(dateString: Date().dateString())
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func config(dateString: String) {
		let date = Date.from(string: dateString)
        monthLB.text = date.monthName(ofStyle: Date.MonthNameStyle.threeLetters)
		dayLB.text = "\(date.day)"
	}
	
}

extension CalendarCard {
	
	private func setupUI() {
		let cornerView = UIView()
		cornerView.backgroundColor = R.color.mainRed()
		cornerView.cornerRadius = 1/2.0
		self.addSubview(cornerView)
		self.addSubview(dayLB)
		self.addSubview(monthLB)
		
		cornerView.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(dayLB.snp_top).offset(2)
			make.size.equalTo(CGSize(width: 10, height: 1))
		}
		
		monthLB.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().offset(3.auto())
		}
		
		dayLB.snp_makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().offset(8.auto())
		}
		
		self.cornerRadius = 5.auto()
		self.layer.borderColor = R.color.background()!.cgColor
		self.layer.borderWidth = 1.auto()
	}
	
	
}
