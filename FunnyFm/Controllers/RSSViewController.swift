//
//  RSSViewController.swift
//  FunnyFm
//
//  Created by wt on 2020/3/21.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit


class RSSViewController: UIViewController {
	
	@IBOutlet var opmlBtn: UIButton!
	
	@IBOutlet var rssBtn: UIButton!
	
	@IBOutlet var tipLB: UILabel!

    @IBOutlet weak var rssTextView: GFLimitTextView!
    
    var actionBlock: ((String)->Void)?
	
	var opmlBlock: ((String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rssTextView.limitLB.isHidden = true
        self.rssTextView.placeText = "输入 RSS 订阅源地址".localized
		self.rssBtn.isSelected = true
		opmlBtn.titleLabel?.font = p_bfont(16)
    }

    @IBAction func addFromRss(_ sender: Any) {
		self.view.endEditing(true)
        guard rssTextView.textView.text.count > 10 else {
            return
        }
        
		if actionBlock.isSome && rssBtn.isSelected {
            self.actionBlock!(self.rssTextView.textView.text)
			self.dismiss(animated: true, completion: nil)
			return
        }
		
//		if opmlBlock.isSome && opmlBtn.isSelected {
//            self.actionBlock!(self.rssTextView.textView.text)
//        }
		parserOPML()
    }
	
	
	func parserOPML() {
		guard let url = URL(string: self.rssTextView.textView.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
			showAutoHiddenHud(style: .error, text: "OPML 链接格式错误")
			return
		}
		let opmlData = try? Data(contentsOf: url)
		guard let data = opmlData, let opmlString = String.init(data: data, encoding: .utf8) else {
			showAutoHiddenHud(style: .error, text: "OPML 内容格式错误")
			return
		}
		let parser = Parser(text: opmlString)
		let _ = parser.success { (items) in
			// TODO: 添加 OPML 播客列表展示
			print(items)
		}
		
		let _ = parser.failure { (error) in
			showAutoHiddenHud(style: .error, text: "OPML 内容解析失败")
			print(error)
		}
		
		parser.main()
		
//		do{
////			let opmlFile = try String(contentsOfFile: self.rssTextView.textView.text, encoding: String.Encoding.utf8)
//			let parser = Parser(text: self.rssTextView.textView.text)
//
//			parser.success { (items) in
//				print(items)
//			}
//
//			parser.failure { (error) in
//				print(error)
//			}
//
//		}catch {
//			showAutoHiddenHud(style: .error, text: "OPML 链接格式错误")
//		}
		
		
	}
	
	@IBAction func rssAction(_ sender: UIButton) {
		rssBtn.isSelected = true;
		rssBtn.titleLabel?.font = p_bfont(24)
		opmlBtn.isSelected = false;
		opmlBtn.titleLabel?.font = p_bfont(16)
		self.tipLB.text = "通过 RSS 链接订阅播客".localized;
		self.rssTextView.placeText = "输入 RSS 订阅源地址".localized
		
	}
	
	@IBAction func opmlAction(_ sender: UIButton) {
		rssBtn.isSelected = false;
		rssBtn.titleLabel?.font = p_bfont(16)
		opmlBtn.isSelected = true;
		opmlBtn.titleLabel?.font = p_bfont(24)
		self.tipLB.text = "通过 OPML 链接订阅播客".localized;
		self.rssTextView.placeText = "输入 OPML 订阅源地址".localized
	}
	
}
