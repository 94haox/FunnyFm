//
//  Pod.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Pod : Mapable{
    var name:       String
    var weburl:     String
    var des:        String
    var img:        String
    var sourceType: String
    var update_time:String
    var last_episode_title:String
    var albumId:    Int
    var count:      Int
    
    init?(jsonData:JSON) {
        name = jsonData["name"].stringValue
        weburl = jsonData["weburl"].stringValue
        des = jsonData["des"].stringValue
        img = jsonData["img"].stringValue
        sourceType = jsonData["sourceType"].stringValue
        albumId = jsonData["albumId"].intValue
        count = jsonData["count"].intValue
        update_time = jsonData["update_time"].stringValue
        last_episode_title = jsonData["last_chapter_title"].stringValue
    }

    
    enum CodingKeys : String, CodingKey {
        case name
        case weburl
        case des
        case img
        case sourceType
        case author
        case albumId
        case count
        case update_time
        case last_episode_title
    }
    
    
}
