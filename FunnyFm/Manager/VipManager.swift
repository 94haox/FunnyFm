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
    
    var vipVaildDate: Date? {
        get {
            let dateString = try? FunnyFm.keychain.get("FunnyFM-VipVaildDate")
            if let _ = dateString {
                return Date.date(withString: dateString!)
            }
            return nil
        }
        set {
            if let _ = newValue {
                try? FunnyFm.keychain.set(newValue!.string(), key: "FunnyFM-VipVaildDate")
            }
        }
    }
        
    func updateVipVailDate(type: Product, trainsationDate: Date?) {
        guard let date = trainsationDate else {
            return
        }
        switch type {
        case .forever:
            self.vipVaildDate = date.adding(.year, value: 99)
            break
        case .year:
            self.vipVaildDate = date.adding(.year, value: 1)
            break
        default:
            self.vipVaildDate = date.adding(.month, value: 1)
            break
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
                let purchase = results.restoredPurchases.last!
                self.updateVipVailDate(type: Product(rawValue: purchase.productId)!, trainsationDate: purchase.transaction.transactionDate)
                print(results.restoredPurchases)
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
                self.updateVipVailDate(type: Product(rawValue: purchase.productId)!, trainsationDate: purchase.transaction.transactionDate)
                print("Purchase Success: \(purchase.productId)")
                complete(true)
            case .error(let error):
                print("Purchase failure: \(error.localizedDescription)")
                complete(false)
            }
        }
    }
    
}
