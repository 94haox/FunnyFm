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


struct Episode : TableCodable{
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
	
	init(feedItem: RSSFeedItem) {
		title = feedItem.title ?? ""
		pubDate = feedItem.pubDate?.dateString() ?? Date().dateString()
//		pubDateSecond = Date().secondsSince(feedItem.pubDate!)
		pubDateSecond = NSDate.minuteOffsetBetweenStart(feedItem.pubDate!, end: Date.init(timeIntervalSince1970: 1))
		intro = feedItem.description ?? "暂无"
		author = feedItem.iTunes?.iTunesAuthor ?? ""
		coverUrl = feedItem.iTunes?.iTunesImage?.attributes?.href ?? ""
		trackUrl = feedItem.enclosure?.attributes?.url ?? ""
		download_filpath = ""
		duration = feedItem.iTunes?.iTunesDuration ?? 0
		podCoverUrl = ""
		collectionId = ""
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
    }
	
	func isFavor(trackUrl:String) -> Bool{
		return self.trackUrl == trackUrl
	}
    
}


