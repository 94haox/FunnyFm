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
	var podId: String
	var podDes: String
	var podAuthor: String
	var trackName:     String
	var trackCount:     String
	var collectionId:     String
	var artworkUrl600:     String
	var feedUrl:     	String
	var releaseDate: 	String
	var copyRight: 	String
	
	
	init?(jsonData:JSON) {
		if jsonData["rss_url"].stringValue.length() > 0 {
			feedUrl = jsonData["rss_url"].stringValue
			trackName = jsonData["track_name"].stringValue
			collectionId = jsonData["collection_id"].stringValue
			artworkUrl600 = jsonData["artwork_url"].stringValue
			releaseDate = jsonData["update_time"].stringValue
			podAuthor = jsonData["author"].stringValue
			podDes = jsonData["desc"].stringValue
			trackCount = jsonData["episode_count"].stringValue
			copyRight = ""
			podId = jsonData["_id"].stringValue
		}else{
			feedUrl = jsonData["feedUrl"].stringValue
			trackName = jsonData["trackName"].stringValue
			collectionId = jsonData["collectionId"].stringValue
			artworkUrl600 = jsonData["artworkUrl600"].stringValue
			trackCount = jsonData["trackCount"].stringValue
			releaseDate = jsonData["releaseDate"].stringValue
			podId = ""
			podAuthor = ""
			copyRight = ""
			podDes = ""
		}
	}
	
	init(pod: Pod) {
		feedUrl = pod.url
		trackName = pod.title
		collectionId = ""
		artworkUrl600 = pod.image
		trackCount = String(pod.items.count)
		releaseDate = pod.updateTime
		podId = ""
		podAuthor = pod.author
		copyRight = pod.copyright
		podDes = pod.description
	}
	
	init(dic:NSDictionary) {
		let rss_url = dic["rss_url"] as! String
		if rss_url.length() > 0 {
			feedUrl = dic["rss_url"] as! String
			trackName = dic["track_name"] as! String
			collectionId = dic["collection_id"] as! String
			artworkUrl600 = dic["artwork_url"] as! String
			releaseDate = dic["update_time"] as! String
			trackCount = "0"
			podAuthor = ""
			copyRight = ""
			podDes = ""
			podId = dic["_id"] as! String
		}else{
			feedUrl = dic["feedUrl"] as! String
			trackName = dic["trackName"] as! String
			collectionId = dic["collectionId"] as! String
			artworkUrl600 = dic["artworkUrl600"] as! String
			trackCount = dic["trackCount"] as! String
			releaseDate = dic["releaseDate"] as! String
			podId = ""
			podAuthor = ""
			copyRight = ""
			podDes = ""
		}
	}
	
	enum CodingKeys : String, CodingKey,CodingTableKey {
		typealias Root = iTunsPod
		static let objectRelationalMapping = TableBinding(CodingKeys.self)
		case podDes
		case trackName
		case feedUrl
		case collectionId
		case artworkUrl600
		case trackCount
		case releaseDate
		case podId
		case podAuthor
		case copyRight
	}
}
