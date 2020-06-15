//
//  ActionViewController.swift
//  FunnyFmImport
//
//  Created by 吴涛 on 2020/6/12.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import MobileCoreServices
import SnapKit
import AutoInch

class ActionViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.handleInputItem()
	}
	
	private func handleInputItem() {
		print("\(self.extensionContext!.inputItems)")
		
		ExtensionItemHandler.handleInputItem(items: self.extensionContext!.inputItems, firstResponder: self) { (isSupport) in
			if !isSupport {
				self.alert("错误", message: "不支持的导入类型") { [weak self] action in
					self?.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
				}
			}else{
				self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
			}
		}
	}
	


	@IBAction func next(_ sender: Any) {
		self.alert("将在下次打开 FunnyFm 时完成操作") { [weak self] action in
			self?.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
		}
	}

}
