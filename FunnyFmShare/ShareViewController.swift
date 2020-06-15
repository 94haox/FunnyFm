//
//  ShareViewController.swift
//  FunnyFmShare
//
//  Created by 吴涛 on 2020/6/15.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeXML as String) {
					return true
                }
				
				if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
					return true
                }
            }
        }
		self.alert("错误", message: "不支持的分享类型")
        return false
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
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

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
