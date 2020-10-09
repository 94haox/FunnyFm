//
//  Chapter.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation

#if canImport(SwiftyJSON)
import SwiftyJSON
#endif

struct Episode: Identifiable{
    var collectionId:              String
    var title:                  String
    var intro:                  String
    var author:                 String
    var duration:               Double
    var trackUrl:                  String
    var coverUrl:                 String
    var podcastUrl:             String
    var podCoverUrl:             String
    var pubDate:                 String
    var pubDateSecond:             Int
    var download_filpath:       String
    var downloadSize:             String
    var id = UUID().uuidString
}


extension Episode: Codable {
	
    #if canImport(SwiftyJSON)
	init?(jsonData:JSON) {
		let time = jsonData["created"].intValue / 1000
		title = jsonData["title"].stringValue
		pubDate = Date.init(timeIntervalSince1970: TimeInterval(time)).dateString()
		if let minte = Date.minuteOffsetBetweenStartDate(startDate: Date.init(timeIntervalSince1970: TimeInterval(time)), endDate: Date.init(timeIntervalSince1970: 1)) {
			pubDateSecond = minte
		} else {
			pubDateSecond = 0
		}
		intro = jsonData["description"].stringValue
		author = jsonData["itunes_author"].stringValue
		coverUrl = jsonData["image"].stringValue
		trackUrl = jsonData["url"].stringValue
		if jsonData["itunes_duration"].stringValue.contains(":") {
			duration = Date.convertDuration(to: jsonData["itunes_duration"].stringValue)
		}else{
			duration =  jsonData["itunes_duration"].doubleValue
		}
		download_filpath = ""
		podCoverUrl = ""
		podcastUrl = ""
		collectionId = ""
		downloadSize = ""
	}
    
    init(data: Data) {
        let jsonData = JSON(data)
        title = jsonData["title"].stringValue
        pubDate = jsonData["pubDate"].stringValue
        pubDateSecond = jsonData["pubDateSecond"].intValue
        intro = jsonData["intro"].stringValue
        author = jsonData["author"].stringValue
        coverUrl = jsonData["coverUrl"].stringValue
        trackUrl = jsonData["trackUrl"].stringValue
        duration =  jsonData["duration"].doubleValue
        podCoverUrl = jsonData["podCoverUrl"].stringValue
        podcastUrl = jsonData["podcastUrl"].stringValue
        download_filpath = ""
        collectionId = ""
        downloadSize = ""
    }
    #endif
        	
	func isFavor(trackUrl:String) -> Bool{
		return self.trackUrl == trackUrl
	}
    
    func toData() -> Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        }catch {
            return nil
        }
    }

    
}

#if canImport(WCDBSwift)

import WCDBSwift

extension Episode: TableCodable {
	
	enum CodingKeys : String, CodingKey,CodingTableKey {
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
		case podcastUrl
		case author
		case collectionId
		case download_filpath
		case downloadSize
		case id
	}

}
#endif


#if canImport(FeedKit)
import FeedKit

extension Episode {
	
	init(feedItem: RSSFeedItem) {
		
		if let pub = feedItem.pubDate {
			pubDate = pub.dateString()
			pubDateSecond = Date.minuteOffsetBetweenStartDate(startDate: pub, endDate: Date.init(timeIntervalSince1970: 1))!
		}else{
			pubDate = Date().dateString()
			pubDateSecond = Date.minuteOffsetBetweenStartDate(startDate: Date(), endDate: Date.init(timeIntervalSince1970: 1))!
		}
		
		if let tit = feedItem.title {
			title = tit
		}else{
			title = ""
		}
		
		if let des = feedItem.description {
			intro = des
		}else{
			intro = ""
		}
		
		if let auth = feedItem.author {
			author = auth
		}else{
			author = ""
		}
		
		if let href = feedItem.iTunes?.iTunesImage?.attributes?.href {
			coverUrl = href
		}else{
			coverUrl = ""
		}
		
		if let url = feedItem.enclosure?.attributes?.url {
			trackUrl = url
		}else{
			trackUrl = ""
		}
		
		if let dur = feedItem.iTunes?.iTunesDuration {
			duration = dur
		}else{
			duration = 0
		}
		
		download_filpath = ""
		podCoverUrl = ""
		podcastUrl = ""
		collectionId = ""
		downloadSize = ""
	}
}

#endif

extension Episode: Hashable {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(trackUrl)
		hasher.combine(pubDate)
		hasher.combine(podcastUrl)
	}
	
	static func == (lhs: Episode, rhs: Episode) -> Bool {
		return lhs.trackUrl == rhs.trackUrl && lhs.podcastUrl == rhs.podcastUrl
	}

}


