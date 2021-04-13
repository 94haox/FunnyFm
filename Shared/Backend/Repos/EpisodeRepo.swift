//
//  EpisodeRepo.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import CoreData

class EpisodeRepo {
    
    
    func fetchAllEpisodeFromDB(with limit: Int? = nil,
                               offset: Int? = nil) -> [Episode] {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<CDEpisode>(entityName: "CDEpisode")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDEpisode.pubDateSecond), ascending: true)
        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }
        if let offset = offset {
            fetchRequest.fetchOffset = offset
        }
        fetchRequest.sortDescriptors = [sortDescriptor]
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        do {
            let episodes = try viewContext.fetch(fetchRequest)
            return episodes.map({Episode(ep: $0)})
        } catch {
            return []
        }
    }
    
    func fetchEpisodesFromDB(with podcast: GPodcast,
                             limit: Int? = nil,
                             offset: Int? = nil) -> [Episode] {
        let fetchRequest = NSFetchRequest<CDEpisode>(entityName: "CDEpisode")
        let pre = NSPredicate.init(format: "podcastUrl = %@", podcast.rss_url)
        fetchRequest.predicate = pre
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDEpisode.pubDateSecond), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }
        if let offset = offset {
            fetchRequest.fetchOffset = offset
        }
        let viewContext = PersistenceController.shared.container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        do {
            let episodes = try viewContext.fetch(fetchRequest)
            return episodes.map({Episode(ep: $0)})
        } catch {
            return []
        }
    }
    
    func fetchAllEpisodesFromServer(with pods: [GPodcast],
                                    completion: @escaping () -> Void) {
        let group = DispatchGroup()
        for pod in pods {
            group.enter()
            fetchEpisodesFromServer(with: pod) {
                completion()
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func fetchEpisodesFromServer(with pod: GPodcast,
                                 completion: @escaping () -> Void) {
        PodcastParser.parserByFeedKit(podcast: pod) { (result) in
            switch result {
                case .success(let feed):
                    guard let items = feed.rssFeed?.items else {
                        completion()
                        return
                    }
                    PersistenceController.shared.saveEpisodes(with: items, podcast: pod)
                    completion()
                default:
                    completion()
                    return
            }
        }
    }
    
}
