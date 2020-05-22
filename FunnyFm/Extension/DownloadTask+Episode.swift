//
//  DownloadTask+Episode.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/5/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import Tiercel

extension DownloadTask {
    
    var episode: Episode? {
		let opUrl = self.url.absoluteString.removingPercentEncoding;
		guard let url = opUrl else {
			return nil
		}
        return DatabaseManager.getEpisode(trackUrl: url)
    }
    
    
    
}
