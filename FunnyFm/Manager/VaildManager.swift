//
//  VaildManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/7.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class VaildManager: NSObject {
    
    static func isMail(_ email: String) -> Bool{
        let regex = "^([a-zA-Z0-9]+([._\\-])*[a-zA-Z0-9]*)+@([a-zA-Z0-9])+(.([a-zA-Z])+)+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

}
