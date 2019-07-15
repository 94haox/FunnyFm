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
	var pubDateSecond:         	Double
    var download_filpath:        String
	
	init(feedItem: RSSFeedItem) {
		title = feedItem.title!
		pubDate = feedItem.pubDate!.dateString()
		pubDateSecond = Date().secondsSince(feedItem.pubDate!)
		download_filpath = ""
		trackUrl = feedItem.enclosure!.attributes!.url!
		if feedItem.iTunes!.iTunesDuration.isSome {
			duration = feedItem.iTunes!.iTunesDuration!
		}else{
			duration = 0;
		}
		
		if feedItem.description.isSome {
			intro = feedItem.description!
		}else{
			intro = ""
		}
		
		if feedItem.iTunes!.iTunesAuthor.isSome {
			author = feedItem.iTunes!.iTunesAuthor!
		}else{
			author = ""
		}
		
		if let image = feedItem.iTunes?.iTunesImage {
			coverUrl = image.attributes!.href!
		}else{
			coverUrl = ""
		}
		podCoverUrl = ""
		collectionId = ""
	}
	
//    init?(jsonData:JSON) {
//        albumId = jsonData["albumId"].intValue
//        trackId = jsonData["trackId"].intValue
//        title = jsonData["title"].stringValue
//        intro = jsonData["intro"].stringValue
//        trackUrl_high = jsonData["trackUrl_high"].stringValue
//        cover_url_high = jsonData["cover_url_high"].stringValue
//        duration = jsonData["duration"].intValue
//        time_until_now = jsonData["time_until_now"].stringValue
//        formatted_created_at = jsonData["formatted_created_at"].stringValue
//        pod_cover_url = jsonData["pod_cover_url"].stringValue
//        pod_name = jsonData["pod_name"].stringValue
//        episodeId = jsonData["_id"].stringValue
//        isFavour = jsonData["isFavour"].boolValue
//        download_filpath = ""
//    }
    
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


