//
//  GlobalConfig.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import UIKit


public func configureNavigationTabBar() {
    //transparent background
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = true
    
    let shadow = NSShadow()
    shadow.shadowOffset = CGSize(width: 0, height: 2)
    shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    
    UINavigationBar.appearance().titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: shadow,
    ]
}
