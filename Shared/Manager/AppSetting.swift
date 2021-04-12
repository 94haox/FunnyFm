//
//  AppSetting.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import Foil

final class AppSettings {
    static let shared = AppSettings()
}


final class PlaySettings {
    static let shared = PlaySettings()
    
    @WrappedDefault(keyName: "defultPlayRate", defaultValue: 1)
    var defultRate: Float
    
}
