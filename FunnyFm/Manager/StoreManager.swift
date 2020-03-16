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
        SwiftyStoreKit.retrieveProductsInfo(["10001"]) { (result) in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(result.error)")
            }
        }
    }
    
    func completeTransactions() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                   if purchase.needsFinishTransaction {
                       // Deliver content from server, then:
                       SwiftyStoreKit.finishTransaction(purchase.transaction)
                   }
                   print("purchased: \(purchase)")
                }
            }
        }
    }
    
    func restorePurchase() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    func purchaseProduct(productId: String, complete: @escaping ((Bool)->Void)) {
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                complete(true)
            case .error(let error):
                complete(false)
            }
        }
    }
}
