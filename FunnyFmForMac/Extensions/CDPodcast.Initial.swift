//
//  CDPodcast.Initial.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import CoreData

extension CDPodcast {
    func setup(with podcast: GPodcast) {
        id = podcast.id
        artwork_url = podcast.artwork_url
        rss_url = podcast.rss_url
        author = podcast.author
        update_time = podcast.update_time
        collection_id = podcast.collection_id
        needVpn = podcast.needVPN
        desc = podcast.desc
        track_name = podcast.track_name
    }
}
