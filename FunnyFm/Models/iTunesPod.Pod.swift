//
//  iTunesPod.Pod.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/10/16.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation

extension iTunsPod {
    
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
        if let podcast = DatabaseManager.getPodcast(feedUrl: feedUrl) {
            isNeedVpn = podcast.isNeedVpn
        }else{
            isNeedVpn = false
        }
    }
    
}
