//
//  ExtensionItemHandler.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/15.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

class ExtensionItemHandler : NSObject {

	static func handleInputItem(items: [Any], firstResponder: UIResponder?, complete: @escaping ((Bool) -> Void)) {
		guard let inputItems = items as? [NSExtensionItem], inputItems.count == 1 else {
			complete(false)
			return
		}
		let item = inputItems.first!
		for provider in item.attachments! {
			if provider.hasItemConformingToTypeIdentifier(kUTTypeXML as String) {
			   provider.loadItem(forTypeIdentifier: kUTTypeXML as String, options: nil, completionHandler: { (xmlUrl, error) in
					guard let url = xmlUrl as? URL else {
					   complete(false)
					   return
					}
					self.parserOPML(exportUrl: url, firstResponder: firstResponder)
					complete(true)
			   })
			}else if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
				provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (feedUrl, error) in
					guard let url = feedUrl as? URL else {
						complete(false)
						return
					}
					if url.absoluteString.hasSuffix(".mp3") || url.absoluteString.hasSuffix(".m4a") {
						complete(false)
						return
					}
					self.parserRss(rss: url, firstResponder: firstResponder)
					complete(true)
				})
			}
		}
	}
	
	static private func parserOPML(exportUrl: URL, firstResponder: UIResponder?) {
		let data = try? Data(contentsOf: exportUrl)
		let shared = UserDefaults.init(suiteName: "group.com.duke.Pine")
		shared?.set(data, forKey: exportUrl.absoluteString)
		shared?.synchronize()
		var responder = firstResponder
		let scheme = "funnyfm://import?\(exportUrl)"
		let url: URL = URL(string: scheme)!
		let context = NSExtensionContext()
		context.open(url, completionHandler: nil)
		let selectorOpenURL = sel_registerName("openURL:")
		while (responder != nil) {
			if responder!.responds(to: selectorOpenURL) {
				responder!.perform(selectorOpenURL, with: url)
				break
			}
			responder = responder?.next
		}
	}
	
	static private func parserRss(rss: URL, firstResponder: UIResponder?) {
		var responder = firstResponder
		let scheme = "funnyfm://rss?\(rss)"
        let url: URL = URL(string: scheme)!
        let context = NSExtensionContext()
        context.open(url, completionHandler: nil)
        let selectorOpenURL = sel_registerName("openURL:")
        while (responder != nil) {
            if responder!.responds(to: selectorOpenURL) {
                responder!.perform(selectorOpenURL, with: url)
                break
            }
            responder = responder?.next
        }
	}
}
