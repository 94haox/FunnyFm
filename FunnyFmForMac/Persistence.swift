//
//  Persistence.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import CoreData
import FeedKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "FunnyFmForMac")
        print(FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask))
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension PersistenceController  {
    func fetchPodcast(with rssUrl: String) -> CDPodcast? {
        let viewContext = container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        let fetchRequest = NSFetchRequest<CDPodcast>(entityName: "CDPodcast")
        let pre = NSPredicate(format: "rss_url = %@", rssUrl)
        fetchRequest.predicate = pre
        do {
            let podcast = try viewContext.fetch(fetchRequest).first
            return podcast
        } catch {
            return nil
        }
    }
}

extension PersistenceController {
    
    func savePodcast(with podcast: GPodcast) {
        let viewContext = container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        
        if let _ = fetchPodcast(with: podcast.rss_url) {
            return
        }
        
        guard let item = NSEntityDescription.insertNewObject(forEntityName: "CDPodcast", into: viewContext) as? CDPodcast else {
            return
        }
        item.setup(with: podcast)
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print("save podcast error \(error.localizedDescription)")
            }
        }
    }
    
    func saveEpisodes(with feedItems: [RSSFeedItem],
                     podcast: GPodcast) {
        guard let pod = fetchPodcast(with: podcast.rss_url) else {
            return
        }
        let viewContext = container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        for feedItem in feedItems {
            var episode = Episode(feedItem: feedItem)
            episode.podcastUrl = podcast.rss_url
            episode.podCoverUrl = podcast.artwork_url
            episode.author = episode.author.count > 1 ? episode.author : podcast.track_name
            if CDEpisode.isExsit(with: episode.trackUrl) {
                continue
            }
            guard let item = NSEntityDescription.insertNewObject(forEntityName: "CDEpisode", into: viewContext) as? CDEpisode else {
                continue
            }
            item.setup(ep: episode)
            pod.addToEpisodes(item)
            do {
                try viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func saveEpisode(with feedItem: RSSFeedItem,
                     podcast: GPodcast) {
        guard let pod = fetchPodcast(with: podcast.rss_url) else {
            return
        }
        let viewContext = container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        var episode = Episode(feedItem: feedItem)
        episode.podcastUrl = podcast.rss_url
        episode.podCoverUrl = podcast.artwork_url
        episode.author = episode.author.count > 0 ? episode.author : podcast.track_name
        guard let item = NSEntityDescription.insertNewObject(forEntityName: "CDEpisode", into: viewContext) as? CDEpisode else {
            return
        }
        item.setup(ep: episode)
        pod.addToEpisodes([item])
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
}
