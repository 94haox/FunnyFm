//
//  SubscribeRepo.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import Combine

class SubscribRepo {
    
    private var disposables: [AnyCancellable?] = []
    
    func getSubscribes(completion: @escaping ([GPodcast]?) -> Void) {
        let cancelable = GPodcast.fetchSubscribes()?
                .sink(receiveCompletion: { (error) in
            completion(nil)
        }, receiveValue: { (data) in
            completion(data.data?.items)
        })
        disposables.append(cancelable)
    }
    
    
}

