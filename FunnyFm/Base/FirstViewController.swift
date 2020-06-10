//
//  FirstViewController.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/9.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.addSubview(self.topBgView)
        self.topBgView.addSubview(self.backNaviBtn)
		self.topBgView.addSubview(self.titleLB)
		self.titleLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.view.snp.topMargin)
            make.left.equalToSuperview().offset(16).priorityMedium()
            make.left.equalTo(self.backNaviBtn.snp_right).offset(10).priorityHigh()
		}
		
		self.topBgView.snp.makeConstraints { (make) in
			make.width.equalToSuperview()
            make.left.equalToSuperview()
			make.top.equalTo(self.view)
			make.height.equalTo( 40 + UIApplication.shared.statusBarFrame.height);
		}
        
        self.backNaviBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLB)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        if self.backNaviBtn.isHidden {
            self.backNaviBtn.removeFromSuperview()
        }
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	
    

	lazy var titleLB: UILabel = {
		let lb = UILabel.init()
		lb.font = p_bfont(subtitleFontSize)
		lb.textColor = CommonColor.subtitle.color
		return lb
	}()
    
    lazy var backNaviBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImageForAllStates(UIImage.init(named: "back-white")!)
        button.backgroundColor = R.color.mainRed()
        button.cornerRadius = 4.auto()
        button.isHidden = true
        return button
    }()
	
	lazy var topBgView: UIView = {
		let view = UIView.init()
        view.backgroundColor = CommonColor.white.color
		return view;
	}()

}
