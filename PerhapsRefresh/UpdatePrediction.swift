//
//  UpdatePrediction.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/10/16.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation


class UpdatePrediction {
    
    func prediction(rss: String) {
        let podcast = DatabaseManager.getPodcast(feedUrl: rss)
        for episode in DatabaseManager.allEpisodes(rss: rss) {
            
        }
        
    }
    
    
}
