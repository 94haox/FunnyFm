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

class SubscribeViewModel: ObservableObject {
    
    @Published public private(set) var podcasts: [GPodcast]
    
    @Published public var selectionPodcast: GPodcast?
    
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
        DispatchQueue.global().async {
            self.fetchSubscribesCancellable = self.subscribeRepo.getSubscribes { [weak self] items in
                guard let self = self,
                      let subs = items else {return}
                DispatchQueue.main.async {
                    self.podcasts = subs.reversed()
                }
            }
        }
    }
}
