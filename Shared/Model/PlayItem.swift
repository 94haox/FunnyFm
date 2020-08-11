//
//  PlayItem.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/25.
//  Copyright © 2019 Duke. All rights reserved.
//

import WCDBSwift

struct PlayItem: TableCodable {
	
	var trackUrl: String
	var playIndex: Int
	
	init(episode: Episode, index: Int) {
		trackUrl = episode.trackUrl
		playIndex = index
	}
	
	enum CodingKeys : String, CodingKey,CodingTableKey {
		typealias Root = PlayItem
		static let objectRelationalMapping = TableBinding(CodingKeys.self)
		case trackUrl
		case playIndex
	}
}
