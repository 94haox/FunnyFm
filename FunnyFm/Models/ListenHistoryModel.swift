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
    
    var chapterId:              String?
    var albumId:                Int
    var trackId:                Int
    var duration:               Int
    var title:                  String?
    var cover_url:              String?
    var intro:                  String?
    var time_until_now:         String?
    
    init(with chapter:Chapter) {
        self.albumId = chapter.albumId
        self.trackId = chapter.trackId
        self.duration = chapter.duration
        self.title = chapter.title
        self.chapterId = chapter.chapterId
        self.cover_url = chapter.cover_url_high
        self.intro = chapter.intro
        self.time_until_now = chapter.time_until_now
        if(chapter.cover_url_normal.count > 1){
            self.cover_url = chapter.cover_url_normal
        }else if(chapter.cover_url_high.count > 1){
            self.cover_url = chapter.cover_url_high
        }
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ListenHistoryModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case albumId
        case trackId
        case duration
        case title
        case chapterId
        case cover_url
        case intro
        case time_until_now
    }
}
