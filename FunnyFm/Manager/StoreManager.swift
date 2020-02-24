//
//  StoreManager.swift
//  FunnyFm
//
//  Created by Duke on 2020/2/12.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class StoreManager: NSObject {
    
    static let shared = StoreManager()
    
    func getAllProducts(){
        SwiftyStoreKit.retrieveProductsInfo(["com.duke.www.FunnyFm"]) { (result) in
            
        }
   }

}
