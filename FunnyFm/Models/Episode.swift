//
//  Chapter.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import SwiftyJSON
import WCDBSwift
import FeedKit


struct Episode : TableCodable,Mapable{
	var collectionId:		  	String
    var title:                String
    var intro:                String
	var author:               String
	var duration:              Double
    var trackUrl:          	String
    var coverUrl:         		String
	var podCoverUrl:         	String
    var pubDate:         		String
	var pubDateSecond:         	Int
    var download_filpath:        String
	var downloadSize: 			String
	
	init(feedItem: RSSFeedItem) {
		title = feedItem.title ?? ""
		pubDate = feedItem.pubDate?.dateString() ?? Date().dateString()
		pubDateSecond = NSDate.minuteOffsetBetweenStart(feedItem.pubDate!, end: Date.init(timeIntervalSince1970: 1))
		intro = feedItem.description ?? "暂无"
		author = feedItem.iTunes?.iTunesAuthor ?? ""
		coverUrl = feedItem.iTunes?.iTunesImage?.attributes?.href ?? ""
		trackUrl = feedItem.enclosure?.attributes?.url ?? ""
		download_filpath = ""
		duration = feedItem.iTunes?.iTunesDuration ?? 0
		podCoverUrl = ""
		collectionId = ""
		downloadSize = ""
	}
	
	init?(jsonData:JSON) {
		let time = jsonData["created"].intValue / 1000
		title = jsonData["title"].stringValue
		pubDate = Date.init(timeIntervalSince1970: TimeInterval(time)).dateString()
		pubDateSecond = NSDate.minuteOffsetBetweenStart(Date.init(timeIntervalSince1970: TimeInterval(time)), end: Date.init(timeIntervalSince1970: 1))
		intro = jsonData["description"].stringValue
		author = jsonData["itunes_author"].stringValue
		coverUrl = jsonData["image"].stringValue
		trackUrl = jsonData["url"].stringValue
		if jsonData["itunes_duration"].stringValue.contains(":") {
			duration = FunnyFm.convertDuration(to: jsonData["itunes_duration"].stringValue)
		}else{
			duration =  jsonData["itunes_duration"].doubleValue
		}
		download_filpath = ""
		podCoverUrl = ""
		collectionId = ""
		downloadSize = ""
	}
	
    
    enum CodingKeys : String ,CodingTableKey {
        typealias Root = Episode
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
		case title
		case intro
		case duration
        case pubDate
		case pubDateSecond
        case trackUrl
		case coverUrl
		case podCoverUrl
		case author
		case collectionId
        case download_filpath
		case downloadSize
    }
	
	func isFavor(trackUrl:String) -> Bool{
		return self.trackUrl == trackUrl
	}
    
}


