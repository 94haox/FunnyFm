//
//  DiscoverViewModel.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation

class DiscoverViewModel: ObservableObject {
 
    @Published var status: FetchStatus = .done
    
    public func fetchDiscoverData() {
        
    }
    
}
