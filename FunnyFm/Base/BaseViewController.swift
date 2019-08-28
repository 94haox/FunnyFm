//
//  BaseViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white
		self.view.addSubview(self.titleLB)
		self.titleLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.view.snp.topMargin)
			make.left.equalToSuperview().offset(16)
		}
    }
	
	
	lazy var titleLB: UILabel = {
		let lb = UILabel.init()
		lb.font = p_bfont(titleFontSize)
		lb.textColor = CommonColor.subtitle.color
		return lb
	}()
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
