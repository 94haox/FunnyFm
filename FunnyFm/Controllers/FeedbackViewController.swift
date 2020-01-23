//
//  FeedbackViewController.swift
//  FunnyFm
//
//  Created by Duke on 2020/1/23.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import WebKit

class FeedbackViewController: BaseViewController {

	let webview: WKWebView = WKWebView.init(frame: CGRect.zero)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "Feedback"
		self.view.addSubview(webview)
		webview.snp.makeConstraints { (make) in
			make.left.bottom.width.equalToSuperview()
			make.top.equalTo(self.topBgView.snp_bottom)
		}
        
		let requst = NSMutableURLRequest.init(url: URL.init(string: "https://support.qq.com/products/119714")!)
		webview.load(requst as URLRequest)
    }
    
}
