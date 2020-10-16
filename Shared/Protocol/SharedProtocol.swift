//
//  SharedProtocol.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/10/16.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol Mapable {
    init?(jsonData:JSON)
}
