//
//  ShareViewController.swift
//  FunnyShare
//
//  Created by Duke on 2018/12/29.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Social

var podCastUrl = ""

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
                                podCastUrl = url!.absoluteString
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
        self.redirectToHostApp()
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func redirectToHostApp() {
        let url = URL(string: "funnyfm://itunsUrl=\(podCastUrl)")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    

}
