//
//  FunnyFm.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class FunnyFm: NSObject {
    
    static let baseurl = "https://api.funnyfm.top/api/"
    
    static let jpushAppKey = "96982e6dbcb84da30216bdb1"
    
//    static let baseurl = "http://127.0.0.1:7001/api/"
    
    static func sharedUrl() -> URL?{
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    static func sharedDatabaseUrl() -> URL{
        return self.sharedUrl()!.appendingPathComponent("FunnyFM.db")
    }
}
