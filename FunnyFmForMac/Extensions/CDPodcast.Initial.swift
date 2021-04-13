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
    
    static func fetchOne(with rssUrl: String) -> GPodcast? {
        let fetchRequest = NSFetchRequest<CDPodcast>(entityName: "CDPodcast")
        let pre = NSPredicate.init(format: "rss_url = %@", rssUrl)
        fetchRequest.predicate = pre
        fetchRequest.fetchLimit = 1
        let viewContext = PersistenceController.shared.container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        do {
            guard let pod = try viewContext.fetch(fetchRequest).first else {
                return nil
            }
            return GPodcast(podcast: pod)
        } catch let error {
            print("CDEpisode.fetch error: \(error.localizedDescription)")
            return nil
        }
    }
}
