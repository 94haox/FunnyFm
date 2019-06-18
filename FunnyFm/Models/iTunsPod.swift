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
	
	init?(jsonData:JSON) {
		feedUrl = jsonData["feedUrl"].stringValue
		trackName = jsonData["trackName"].stringValue
		collectionId = jsonData["collectionId"].stringValue
		artworkUrl600 = jsonData["artworkUrl600"].stringValue
		trackCount = jsonData["trackCount"].stringValue
		releaseDate = jsonData["releaseDate"].stringValue
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
	}
}
