//
//  VipManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SwiftyStoreKit

enum Product : String{
    case month = "10001"
    case year = "10003"
    case forever = "10004"
}


class VipManager: NSObject {
    
    static let shared = VipManager()
    
    var isVip: Bool {
        get {
            if let date = self.vipVaildDate {
                return !date.isInPast
            }
            return false
        }
    }
    
    var allowEpisodeNoti: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "allowEpisodeNoti")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "allowEpisodeNoti")
            PushManager.shared.addAllDatabaseTags()
        }
    }
    
    var vipVaildDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "vipVaildDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "vipVaildDate")
        }
    }
        
    func updateVipVailDate(purchase: Purchase) {
        let payment = purchase.transaction
        self.vipVaildDate = payment.transactionDate!.adding(.month, value: 1)
    }
    
    func getAllProducts(){
        SwiftyStoreKit.retrieveProductsInfo(["10001"]) { (result) in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(result.error?.localizedDescription)")
            }
        }
    }
    
    func completeTransactions() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                   if purchase.needsFinishTransaction {
                       SwiftyStoreKit.finishTransaction(purchase.transaction)
                   }
                   print("purchased: \(purchase)")
                }
            }
        }
    }
    
    func restorePurchase(complete: @escaping ((Bool)-> Void)) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                UIApplication.shared.keyWindow!.rootViewController!.alert("无法连接 iTunes Store，请稍后重试".localized)
                complete(false)
            }
            else if results.restoredPurchases.count > 0 {
                let purchase = results.restoredPurchases.first!
                self.updateVipVailDate(purchase: purchase)
                print(purchase)
                complete(true)
            }
            else {
                complete(false)
                UIApplication.shared.keyWindow!.rootViewController!.alert("无可恢复项".localized)
                print("Nothing to Restore")
            }
        }
    }
    
    func purchaseProduct(productId: String, complete: @escaping ((Bool)->Void)) {
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
//                self.updateVipVailDate(purchase: Purchase(pro))
                print("Purchase Success: \(purchase.productId)")
                complete(true)
            case .error(let error):
                print("Purchase failure: \(error.localizedDescription)")
                complete(false)
            }
        }
    }
    
}
