//
//  PlayList.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import Foil

final class PlayList {
    
    static let shared = PlayList()
    
    @WrappedDefault(keyName: "lastTrackUrl", defaultValue: "")
    var lastItemTrackUrl: String
    
}
