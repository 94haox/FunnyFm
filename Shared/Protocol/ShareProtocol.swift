//
//  ShareProtocol.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol Mapable {
	init?(jsonData:JSON)
}
