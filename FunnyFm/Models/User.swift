//
//  User.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SwiftyJSON

struct User: Mapable {
    var userId:     String
    var name:       String
    var avatar:     String
    var sex:        String
    var registerTime:        String
    
    init?(jsonData:JSON) {
        userId = jsonData["_id"].stringValue
        name = jsonData["name"].stringValue
        avatar = jsonData["avatar"].stringValue
        sex = jsonData["sex"].stringValue
        registerTime = jsonData["register_time"].stringValue
    }
    
    enum CodingKeys : String, CodingKey {
        case userId
        case name
        case avatar
        case sex
        case registerTime
    }
    
}
