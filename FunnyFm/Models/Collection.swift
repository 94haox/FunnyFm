//
//  Collection.swift
//  FunnyFm
//
//  Created by Duke on 2020/1/30.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Collection: Mapable {
	var collectionId: String
	var collectionName: String
	var collectionCover: String
	var desc: String
	var items: Array<iTunsPod>
	
	init?(jsonData:JSON) {
		collectionId = jsonData["_id"].stringValue
		collectionName = jsonData["collection_name"].stringValue
		collectionCover = jsonData["collection_cover"].stringValue
		desc = jsonData["desc"].stringValue
		items = [iTunsPod]()
		jsonData["items"].arrayValue.forEach { (itemJson) in
			let podcast = iTunsPod.init(jsonData: itemJson)
			if podcast.isSome {
				items.append(podcast!)
			}
		}
	}

}
