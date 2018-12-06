//
//  Chapter.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Chapter : Mapable{
    var albumId:                Int
    var trackId:                Int
    var duration:               Int
    var title:                  String
    var intro:                  String
    var trackUrl_high:          String
    var trackUrl_normal:        String
    var cover_url_normal:       String
    var cover_url_high:         String
    var time_until_now:         String
    var formatted_created_at:   String
    
    init?(jsonData:JSON) {
        albumId = jsonData["albumId"].intValue
        trackId = jsonData["trackId"].intValue
        title = jsonData["title"].stringValue
        intro = jsonData["intro"].stringValue
        trackUrl_high = jsonData["trackUrl_high"].stringValue
        trackUrl_normal = jsonData["trackUrl_normal"].stringValue
        trackUrl_normal = jsonData["trackUrl_normal"].stringValue
        cover_url_normal = jsonData["cover_url_normal"].stringValue
        cover_url_high = jsonData["cover_url_high"].stringValue
        duration = jsonData["trackUrl_normal"].intValue
        time_until_now = jsonData["time_until_now"].stringValue
        formatted_created_at = jsonData["formatted_created_at"].stringValue
    }
    
    enum CodingKeys : String, CodingKey {
        case albumId
        case trackId
        case title
        case intro
        case trackUrl_high
        case trackUrl_normal
        case cover_url_normal
        case cover_url_high
        case duration
        case time_until_now
        case formatted_created_at
    }
    
    
}
