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
    var title:       String
	var author: String
	var description:     String
    var url:     String
    var image:        String
	var items: Array<Episode>
	var copyright: String
	var updateTime: String
    
    init?(jsonData:JSON) {
		let time = jsonData["update_time"].intValue / 1000
        title = jsonData["title"].stringValue
		author = jsonData["author"].stringValue
        url = jsonData["url"].stringValue
        description = jsonData["description"].stringValue
		image = jsonData["image"].stringValue
		items = [Episode]()
		copyright = jsonData["copyright"].stringValue
		updateTime = Date.init(timeIntervalSince1970: TimeInterval(time)).dateString()
		jsonData["items"].arrayValue.forEach { (itemJson) in
			let episode = Episode.init(jsonData: itemJson)
			if episode.isSome {
				items.append(episode!)
			}
		}
    }

    
    enum CodingKeys : String, CodingKey {
		case title
		case description
		case url
		case image
		case items
		case copyright
		case updateTime
		case author
    }
    
    
}
