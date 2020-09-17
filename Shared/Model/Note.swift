//
//  Note.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/2.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import SwiftyJSON
import WCDBSwift

struct Note: Mapable {
	var noteId: 			String
	var userId:     		String
	var trackUrl: 		    String
	var noteType:       	Int
	var noteMoment:        	Int
	var noteDesc:        	String
	var isPrivate:       	Bool
	var createTime:        String
	
	init?(jsonData:JSON) {
		noteId = jsonData["_id"].stringValue
		userId = jsonData["user_id"].stringValue
		trackUrl = jsonData["track_url"].stringValue
		noteType = jsonData["note_type"].intValue
		noteMoment = jsonData["note_moment"].intValue
		noteDesc = jsonData["note_desc"].stringValue
		isPrivate = jsonData["is_private"].boolValue
		createTime = jsonData["create_time"].stringValue
	}
	
}
