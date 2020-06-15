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
                    provider.loadItem(forTypeIdentifier: kUTTypeXML as String, options: nil, completionHandler: { (xmlUrl, error) in
						print("-----------\(String(describing: xmlUrl))")
                    })
					return true
                }
				
				if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (url, error) in
						print("++++++++++\(String(describing: url))")
                    })
					return true
                }
            }
        }
		self.alert("错误", message: "不支持的分享类型")
        return false
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
