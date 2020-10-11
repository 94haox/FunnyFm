//
//  Episode.Intent.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import Intents
import os.log

extension Episode {
	
	static func get(intent: INPlayMediaIntent) -> Episode? {
		let items = intent.mediaItems?.compactMap { (item) -> Episode? in
			guard let trackID = item.identifier else {
				return nil
			}
			
			return DatabaseManager.getEpisode(id: trackID)
		}
		return items?.first
	}
	
	func donateEpisode() {
		donateIntent(intent: intent)
	}
	
	func donateIntent(intent: INPlayMediaIntent) {
		let interaction = INInteraction(intent: intent, response: nil)
		
		interaction.groupIdentifier = id
		
		interaction.donate { (error) in
			if error != nil {
				guard let error = error as NSError? else { return }
				os_log("Could not donate interaction %@", error)
			} else {
				os_log("Play request interaction donation succeeded")
			}
		}
	}
	
}

