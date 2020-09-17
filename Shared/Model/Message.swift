//
//  Message.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import SwiftyJSON
import WCDBSwift

struct Message: Mapable,TableCodable {
	var type:     		String
	var title: 		    String
	var subtitle:       String
	var content:        String
	var pubDate:        String
	
	init?(jsonData:JSON) {
		type = jsonData["type"].stringValue
		title = jsonData["title"].stringValue
		subtitle = jsonData["subtitle"].stringValue
		content = jsonData["content"].stringValue
		pubDate = jsonData["pub_date"].stringValue
	}
	
	enum CodingKeys : String, CodingKey ,CodingTableKey{
		typealias Root = Message
		static let objectRelationalMapping = TableBinding(CodingKeys.self)
		case pubDate
		case content
		case subtitle
		case title
		case type
	}
	
}
