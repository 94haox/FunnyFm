//
//  SubscribeRepo.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import Combine
import CoreData

class SubscribRepo {
    
    private var disposables: [AnyCancellable?] = []
    
    func fetchSubscribes(completion: @escaping ([GPodcast]?) -> Void) -> AnyCancellable? {
        let dbResult = self.fetchPodcastsFromDB()
        return self.fetchPodcastsFromServer { (podcasts) in
           guard let pods = podcasts else { return }
           let isEqual = dbResult.elementsEqual(pods) { (item, item2) -> Bool in
               item == item2
           }
           if !isEqual {
               completion(pods)
           }
        }
    }
    
    func fetchPodcastsFromDB() -> [GPodcast] {
        let fetchRequest = NSFetchRequest<CDPodcast>(entityName: "CDPodcast")
        let viewContext = PersistenceController.shared.container.viewContext
        objc_sync_enter(viewContext)
        defer {
            objc_sync_exit(viewContext)
        }
        do {
            let podcasts = try viewContext.fetch(fetchRequest)
            return podcasts.map({GPodcast(podcast: $0)})
        } catch {
            return []
        }
    }
    
    private func fetchPodcastsFromServer(completion: @escaping ([GPodcast]?) -> Void) -> AnyCancellable? {
        let cancelable = GPodcast.fetchSubscribes()?
                .sink(receiveCompletion: { (error) in
            completion(nil)
        }, receiveValue: { (data) in
            self.storePodcasts(data.data?.items)
            completion(data.data?.items)
        })
        return cancelable
    }
    
    private func storePodcasts(_ podcasts: [GPodcast]?) {
        guard let pods = podcasts else {
            return
        }
        pods.forEach { (podcast) in
            PersistenceController.shared.savePodcast(with: podcast)
        }
    }
    
    
}

