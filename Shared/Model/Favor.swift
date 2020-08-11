//
//  Favor.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/5.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import SwiftyJSON
import WCDBSwift

struct Favor: Mapable,TableCodable {
	var userId:     String
	var trackUrl: String
	var favourTime:        String
	
	init?(jsonData:JSON) {
		userId = jsonData["user_id"].stringValue
		trackUrl = jsonData["episode_id"].stringValue
		favourTime = jsonData["favour_time"].stringValue
	}
	
	enum CodingKeys : String, CodingKey ,CodingTableKey{
		typealias Root = Favor
		static let objectRelationalMapping = TableBinding(CodingKeys.self)
		case userId
		case trackUrl
		case favourTime
	}
	
}
