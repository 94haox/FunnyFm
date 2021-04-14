//
//  SubscribeViewModel.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum FetchStatus {
    case loading
    case done
}

class SubscribeViewModel: ObservableObject {
    
    @Published public private(set) var podcasts: [GPodcast]
    
    @Published public var selectionPodcast: GPodcast?
    
    @Published public var fetchStatus: FetchStatus = .done
    
    private var fetchSubscribesCancellable: AnyCancellable?
    
    private let subscribeRepo = SubscribRepo()
    
    init() {
        podcasts = []
        fetchSubscribes()
    }
    
    func fetchSubscribes() {
        guard fetchSubscribesCancellable == nil else {
            return
        }
        fetchStatus = .loading
        let db = subscribeRepo.fetchPodcastsFromDB()
        if db.count > 0 {
            self.podcasts = db.reversed()
            fetchStatus = .done
        }
        DispatchQueue.global().async {
            self.fetchSubscribesCancellable = self.subscribeRepo.fetchSubscribes { [weak self] items in
                DispatchQueue.main.async {
                    self?.fetchStatus = .done
                    guard let self = self,
                          let subs = items else {return}
                    self.podcasts = subs.reversed()
                }
            }
        }
    }
}
