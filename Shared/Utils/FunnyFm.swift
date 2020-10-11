//
//  FunnyFm.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation

#if canImport(KeychainAccess)
import KeychainAccess
#endif

#if canImport(Reachability)
import Reachability
#endif

class FunnyFm: NSObject {

	static let baseurl = "https://api.funnyfm.top/api/"
	
	static let groupId = "group.com.duke.Pine"
    
	#if canImport(KeychainAccess)
	static let keychain = Keychain(service: "com.duke.www.FunnyFm")
	#endif
	
	
	#if canImport(Reachability)

	static let reachability = try! Reachability()
	
	static func startReach() {
		
		FunnyFm.self.reachability.whenReachable = { reachability in
			if reachability.connection == .wifi {
				print("Reachable via WiFi")
			} else {
				print("Reachable via Cellular")
			}
		}
		FunnyFm.self.reachability.whenUnreachable = { _ in
			print("Not reachable")
		}

		do {
			try FunnyFm.self.reachability.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
		
	}
	#endif
    
	#if canImport(UIKit) && canImport(WCDBSwift)
	static func attributePlaceholder(_ placeHolder:String)-> NSAttributedString{
		let attr = NSAttributedString.init(string: placeHolder, attributes: [NSAttributedString.Key.font : pfont(12),NSAttributedString.Key.foregroundColor:CommonColor.content.color])
		return attr
	}
	#endif
	
    static func sharedUrl() -> URL?{
		return FileManager.group
    }
    
    static func sharedDatabaseUrl() -> URL{
        return self.sharedUrl()!.appendingPathComponent("FunnyFM.db")
    }
    
    static func needParser() -> Bool {
        guard let lastParserTime = UserDefaults.standard.object(forKey: "lastParserTime") as? Date else {
            return true
        }
        
		if Date.minuteOffsetBetweenStartDate(startDate:lastParserTime, endDate: Date())! > 5 {
            return true
        }
        
        return false
    }
	
    static func isAutoCacheInWIFI() -> Bool {
		UserDefaults.standard.bool(forKey: "isAutoCacheInWIFI")
    }    
}


extension Date {
	
	static func minuteOffsetBetweenStartDate(startDate: Date, endDate: Date) -> Int? {
		let gregorian = Calendar.init(identifier: Calendar.Identifier.gregorian)
		let comps = gregorian.dateComponents([Calendar.Component.minute], from: startDate, to: endDate)
		let minute = comps.minute
		return minute
	}
	
}

extension UserDefaults {

	static let group = UserDefaults.init(suiteName: FunnyFm.groupId)
	
}

extension FileManager {
	
	static let group = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: FunnyFm.groupId)
	
}

