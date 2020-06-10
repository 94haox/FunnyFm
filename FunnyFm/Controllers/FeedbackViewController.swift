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
		self.title = "Feedback"
		self.view.addSubview(webview)
		webview.snp.makeConstraints { (make) in
			make.left.bottom.width.equalToSuperview()
			make.top.equalTo(self.view)
		}
        
		let requst = NSMutableURLRequest.init(url: URL.init(string: "https://support.qq.com/products/119714")!)
		webview.load(requst as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
