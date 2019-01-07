
//
//  SchemManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/7.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

enum SharePodType {
    case ituns
    case castro
}


class SchemManager: NSObject {
    
    static func shareType(_ url: String) -> SharePodType {
        if url.hasPrefix("https://itunes.apple.com/cn/podcast/") {
            return .ituns
        }
        return .castro
    }
    
    static func processItunsPod(_ url: String) -> String?{
        //https://itunes.apple.com/cn/podcast/ggtalk/id1440443653?mt=2&i=1000426834683
        if let prefix = url.components(separatedBy: "?").first {
            if let idStr = prefix.components(separatedBy: "/").last {
                let id = idStr.subString(from: 2)
                return id
            }
        }
        return nil
    }
    
    
    
    
    
    
    

}
