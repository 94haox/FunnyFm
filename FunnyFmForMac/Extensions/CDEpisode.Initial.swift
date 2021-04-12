//
//  CDEpisode.Initial.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import CoreData
import FeedKit

extension Episode {
    
    init(ep: CDEpisode) {
        podCoverUrl = ep.podCoverUrl ?? ""
        podcastUrl = ep.podcastUrl ?? ""
        collectionId = ep.collectionId ?? ""
        title = ep.title ?? ""
        intro = ep.intro ?? ""
        author = ep.author ?? ""
        duration = ep.duration
        trackUrl = ep.trackUrl ?? ""
        coverUrl = ep.coverUrl ?? ""
        pubDate = ep.pubDate!
        pubDateSecond = Int(ep.pubDateSecond)
        download_filpath = ""
        downloadSize = ""
    }
    
}

extension CDEpisode {
    func setup(ep: Episode) {
        author = ep.author
        collectionId = ep.collectionId
        coverUrl = ep.coverUrl
        intro = ep.intro
        podCoverUrl = ep.podCoverUrl
        podcastUrl = ep.podcastUrl
        pubDate = ep.pubDate
        title = ep.title
        trackUrl = ep.trackUrl
        duration = ep.duration
        pubDateSecond = Int64(ep.pubDateSecond)
    }
}

extension CDEpisode {
    static func isExsit(with trackUrl: String) -> Bool {
        let fetchRequest = NSFetchRequest<CDEpisode>(entityName: "CDEpisode")
        let pre = NSPredicate.init(format: "trackUrl = %@", trackUrl)
        fetchRequest.predicate = pre
        fetchRequest.fetchLimit = 1
        let viewContext = PersistenceController.shared.container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch let error {
            print("CDEpisode.fetch error: \(error.localizedDescription)")
            return false
        }
    }
    
    static func fetchOne(with trackUrl: String) -> Episode? {
        let fetchRequest = NSFetchRequest<CDEpisode>(entityName: "CDEpisode")
        let pre = NSPredicate.init(format: "trackUrl = %@", trackUrl)
        fetchRequest.predicate = pre
        fetchRequest.fetchLimit = 1
        let viewContext = PersistenceController.shared.container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        do {
            guard let ep = try viewContext.fetch(fetchRequest).first else {
                return nil
            }
            return Episode(ep: ep)
        } catch let error {
            print("CDEpisode.fetch error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func count() -> Int? {
        let fetchRequest = NSFetchRequest<CDEpisode>(entityName: "CDEpisode")
        let viewContext = PersistenceController.shared.container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count
        } catch let error {
            print("CDEpisode.fetch error: \(error.localizedDescription)")
            return nil
        }
    }
}

