//
//  ListenHistoryModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import WCDBSwift

class ListenHistoryModel: TableCodable{
    
    var episodeId:              String?
    var albumId:                Int
    var trackId:                Int
    var duration:               Int
    var title:                  String?
    var cover_url:              String?
    var intro:                  String?
    var time_until_now:         String?
    
    init(with episode:Episode) {
        self.albumId = episode.albumId
        self.trackId = episode.trackId
        self.duration = episode.duration
        self.title = episode.title
        self.episodeId = episode.episodeId
        self.cover_url = episode.cover_url_high
        self.intro = episode.intro
        self.time_until_now = episode.time_until_now
        self.cover_url = episode.cover_url_high
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ListenHistoryModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case albumId
        case trackId
        case duration
        case title
        case episodeId
        case cover_url
        case intro
        case time_until_now
    }
}
