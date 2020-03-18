//
//  BaseViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import OfficeUIFabric

class BaseViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .systemBackground
		self.view.addSubview(self.topBgView)
		self.topBgView.addSubview(self.titleLB)
		self.titleLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.view.snp.topMargin)
			make.left.equalToSuperview().offset(16)
		}
		
		self.topBgView.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.top.equalTo(self.view)
			make.height.equalTo( 40 + UIApplication.shared.statusBarFrame.height);
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		MSHUD.shared.hide()
	}
	
	
	lazy var titleLB: UILabel = {
		let lb = UILabel.init()
		lb.font = p_bfont(subtitleFontSize)
		lb.textColor = CommonColor.subtitle.color
		return lb
	}()
	
	lazy var topBgView: UIView = {
		let view = UIView.init()
        view.backgroundColor = CommonColor.white.color
		return view;
	}()
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
       
    }
}
