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

class MainViewModel: ObservableObject {
    
    @Published public private(set) var pods: [GPodcast] = []
    
    private var disposables: [AnyCancellable?] = []
    
    private let subscribeRepo = SubscribRepo()
    
    func getSubscribes() {
        subscribeRepo.getSubscribes { [weak self] items in
            guard let self = self,
                  let subs = items else {return}
            DispatchQueue.main.async {
                self.pods = subs.reversed()
            }
        }
    }
    
}
