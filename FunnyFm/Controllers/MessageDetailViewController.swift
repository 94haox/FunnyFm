//
//  MessageDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class MessageDetailViewController: BaseViewController {
	
	var detailInfoTextView: UITextView = UITextView.init(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "详情".localized
		self.view.backgroundColor = CommonColor.white.color
		self.detailInfoTextView.isEditable = false
		self.detailInfoTextView.backgroundColor = CommonColor.white.color
		self.detailInfoTextView.contentInset = UIEdgeInsets.init(top: 30, left: 20, bottom: 0, right: 30)
		self.detailInfoTextView.font = pfont(fontsize6)
		self.view.addSubview(self.detailInfoTextView)
		self.detailInfoTextView.snp.makeConstraints { (make) in
			make.left.width.bottom.equalToSuperview()
			make.top.equalTo(self.view.snp.topMargin)
		}
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
