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
    
    static func formatIntervalToMM(_ second:NSInteger) -> String {
        
        let hour = second/3600
        let min = second%3600/60
        let sec = second%3600%60
        
        var hourStr = "00:"
        if  hour > 0 {
            hourStr = "0" + String(hour) + ":"
        }
        
        var minStr = "00:"
        if  min > 0 {
            if min > 9 {
                minStr = String(min)
            }else{
                minStr = "0" + String(min)
            }
            minStr = minStr + ":"
        }
        
        var secStr = "00"
        if  sec > 0 {
            if  sec > 9 {
                secStr = String(sec)
            }else{
                secStr = "0" + String(sec)
            }
        }
        
        return hourStr + minStr + secStr
    }
    
}
