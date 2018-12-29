//
//  ShareViewController.swift
//  FunnyShare
//
//  Created by Duke on 2018/12/29.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func presentationAnimationDidFinish() {
        self.extensionContext!.inputItems.forEach { (item) in
            let newItem = item as! NSExtensionItem
            newItem.attachments?.forEach({ (provider) in
                if(provider.hasItemConformingToTypeIdentifier("public.url")){
                    provider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (item, error) in
                        let url = item as? URL
                        if url.isSome{
                            DispatchQueue.main.async(execute: {
                                self.textView.text = url!.absoluteString
                            })
                        }
                    })
                }
            })
        }
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        print(self.extensionContext!.inputItems)
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
