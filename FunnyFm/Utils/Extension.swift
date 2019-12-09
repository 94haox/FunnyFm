//
//  Extension.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    var unicodeStr:String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
	
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
}

extension UIImage {
	
	public func maskWithColor(color: UIColor) -> UIImage {
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		let context = UIGraphicsGetCurrentContext()!
		
		let rect = CGRect(origin: CGPoint.zero, size: size)
		
		color.setFill()
		self.draw(in: rect)
		
		context.setBlendMode(.sourceIn)
		context.fill(rect)
		
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return resultImage
	}
	
}


extension Float {
	func adapt() -> CGFloat{
		return AdaptScale(CGFloat(self))
	}
	
	func adaptH() -> CGFloat {
		return AdaptScaleH(CGFloat(self))
	}
}

extension CGFloat {
	func adapt() -> CGFloat{
		return AdaptScale(self)
	}
	
	func adaptH() -> CGFloat {
		return AdaptScaleH(self)
	}
}

extension Double {
	func adapt() -> CGFloat{
		return AdaptScale(CGFloat(self))
	}
	
	func adaptH() -> CGFloat {
		return AdaptScaleH(CGFloat(self))
	}
}

extension Int {
	func adapt() -> CGFloat{
		return AdaptScale(CGFloat(self))
	}
	
	func adaptH() -> CGFloat {
		return AdaptScaleH(CGFloat(self))
	}
}

extension Notification {
	static let setupNotification = Notification.Name.init(kSetupNotification)
	static let needLoginNotification = Notification.Name.init(kNeedLoginAction)
	static let toMainNotification = Notification.Name.init(kToMainAction)
	static let downloadProgressNotification = Notification.Name.init("downloadprogress")
	static let downloadSuccessNotification = Notification.Name.init("download_success")
	static let downloadFailureNotification = Notification.Name.init("download_failure")
	static let podcastUpdateNewEpisode = Notification.Name.init("podcast_newEpisode_update")
	static let appHasNewVersionReleased = Notification.Name.init("app_HasNewVersionReleased")
	static let appWillOpenH5 = Notification.Name.init("app_willOpenH5")
	static let homeParserSuccess = Notification.Name.init("homechapterParserSuccess")
}


