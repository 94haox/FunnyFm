//
//  RSSViewController.swift
//  FunnyFm
//
//  Created by wt on 2020/3/21.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class RSSViewController: UIViewController {

    @IBOutlet weak var rssTextView: GFLimitTextView!
    
    var actionBlock: ((String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rssTextView.limitLB.isHidden = true
        self.rssTextView.placeText = "输入 RSS 订阅源地址".localized
    }

    @IBAction func addFromRss(_ sender: Any) {
        
        guard rssTextView.textView.text.count > 10 else {
            return
        }
        
        if actionBlock.isSome {
            self.actionBlock!(self.rssTextView.textView.text)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
