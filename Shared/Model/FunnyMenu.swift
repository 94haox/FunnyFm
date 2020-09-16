//
//  FunnyMenu.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/9/16.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation

enum FunnyMenu: Int, CaseIterable {
    case now, discovery, playList, user
    
    func title() -> String {
        switch self {
            case .now: return "Now"
            case .discovery: return "Discovery"
            case .playList: return "PlayList"
            case .user: return "User"
        }
    }
    
    func imageName() -> String {
        switch self {
            case .now: return "main_ipad"
            case .discovery: return "rss_ipad"
            case .playList: return "playlist_ipad"
            case .user: return "user_ipad"
        }
    }
    
    
}
