//
//  CDPodcast.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import CoreData
import Combine

struct GPodcast: Codable, Identifiable {
    var id: String
    var desc: String?
    var author: String?
    var track_name: String
    var collection_id: String?
    var artwork_url: String
    var rss_url: String
    var update_time: String
    var needVPN: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case desc
        case author
        case track_name
        case collection_id
        case artwork_url
        case rss_url
        case update_time
        case needVPN
    }
    
    init(podcast: CDPodcast) {
        id = podcast.id!
        artwork_url = podcast.artwork_url!
        rss_url = podcast.rss_url!
        author = podcast.author
        update_time = podcast.update_time!
        collection_id = podcast.collection_id
        needVPN = podcast.needVpn
        desc = podcast.desc
        track_name = podcast.track_name!
    }
    
}

extension GPodcast: Equatable {
    static func == (lhs: GPodcast, rhs: GPodcast) -> Bool {
        return lhs.id == rhs.id || lhs.rss_url == rhs.rss_url
    }
}

extension GPodcast: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(rss_url)
        hasher.combine(author)
    }
}


extension GPodcast {
    static public func fetchSubscribes() -> AnyPublisher<ListingResponse<GPodcast>, NetworkError>? {
        let params = ["user_id": UserCenter.shared.userId]
        return API.shared.POST(endpoint:.getSubscribeList,
                               params: params)
    }
}
