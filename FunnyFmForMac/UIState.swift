//
//  UIState.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
class UIState: ObservableObject {
    
    public static let shared = UIState()
    
    @Published var sidebarSelection: String? = DefaultChannels.nearest.rawValue
    
    enum DefaultChannels: String, CaseIterable {
        case nearest = "最新"
        case discover = "探索"
        case subscribe = "已订阅"
        
        func icon() -> String {
            switch self {
            case .nearest: return "rosette"
            case .discover: return "flame"
            case .subscribe: return "bookmark"
            }
        }
    }
    
    private init() {
        
    }
}
