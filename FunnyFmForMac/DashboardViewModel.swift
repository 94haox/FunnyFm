//
//  MainViewModel.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    
    @Published public private(set) var selectedEpisode: Episode?
    
    @Published public private(set) var pods: [GPodcast] = []
    
    @Published public private(set) var nearestEpisodes: [Episode]
    
    @Published public var selection: String? {
        didSet {
            guard let id = selection else {
                return
            }
            self.updatePlayEpisode(id: id)
        }
    }
    
    private var disposables: [AnyCancellable?] = []
    
    private let subscribeRepo = SubscribRepo()
    
    private let episodeRepo = EpisodeRepo()
    
    private var fetchSubscribesCancellable: AnyCancellable?
    
    init() {
        nearestEpisodes = []
    }
    
    func updatePlayEpisode(id: String){
        guard let episode = nearestEpisodes.filter({$0.id == id}).first else {
            return
        }
        self.selectedEpisode = episode
        PlayState.shared.config(episode)
    }
    
    func getSubscribes() {
        guard fetchSubscribesCancellable == nil else {
            return
        }
        DispatchQueue.global().async {
            self.fetchSubscribesCancellable = self.subscribeRepo.getSubscribes { [weak self] items in
                guard let self = self,
                      let subs = items else {return}
                DispatchQueue.main.async {
                    self.pods = subs.reversed()
                    self.fetchEpisodes()
                }
            }
        }
    }
    
    func fetchEpisodes() {
        let exsitCount = CDEpisode.count()
        nearestEpisodes = self.episodeRepo.fetchAllEpisodeFromDB(with: 100)
        DispatchQueue.global().async {
            self.episodeRepo.fetchAllEpisodesFromServer(with: self.pods) {[weak self] in
                guard let self = self else {return}
                let count = CDEpisode.count()
                if count == exsitCount {
                    return
                }
                self.nearestEpisodes = self.episodeRepo.fetchAllEpisodeFromDB(with: 100)
            }
        }
    }
    
}
