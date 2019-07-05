//
//  iTunsPod.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/14.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import SwiftyJSON
import WCDBSwift

struct iTunsPod : Mapable, TableCodable {
	var trackName:     String
	var trackCount:     String
	var collectionId:     String
	var artworkUrl600:     String
	var feedUrl:     	String
	var releaseDate: 	String
	var podId: String
	
	init?(jsonData:JSON) {
		if jsonData["rss_url"].stringValue.length() > 0 {
			feedUrl = jsonData["rss_url"].stringValue
			trackName = jsonData["track_name"].stringValue
			collectionId = jsonData["collection_id"].stringValue
			artworkUrl600 = jsonData["artwork_url"].stringValue
			releaseDate = jsonData["update_time"].stringValue
			trackCount = "0"
			podId = jsonData["_id"].stringValue
		}else{
			feedUrl = jsonData["feedUrl"].stringValue
			trackName = jsonData["trackName"].stringValue
			collectionId = jsonData["collectionId"].stringValue
			artworkUrl600 = jsonData["artworkUrl600"].stringValue
			trackCount = jsonData["trackCount"].stringValue
			releaseDate = jsonData["releaseDate"].stringValue
			podId = ""
		}
	}
	
	enum CodingKeys : String, CodingKey,CodingTableKey {
		typealias Root = iTunsPod
		static let objectRelationalMapping = TableBinding(CodingKeys.self)
		case trackName
		case feedUrl
		case collectionId
		case artworkUrl600
		case trackCount
		case releaseDate
		case podId
	}
}
