//
//  HandoffManager.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/8/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import AVFoundation

class HandoffManager: ObservableObject {
	
	static let shared = HandoffManager()
	
	@Published var isVisble = false
	
	@Published var currentEpisode: Episode?
	
	@Published var episodes = [Episode]()
	
	
}

