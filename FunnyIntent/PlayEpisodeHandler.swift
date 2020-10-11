//
//  PlayEpisodeHandler.swift
//  FunnyIntent
//
//  Created by Tao on 2020/10/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import Intents

class PlayEpisodeHandler: INExtension, INPlayMediaIntentHandling {
	
	
	func confirm(intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
		guard let container = intent.mediaContainer,
			  let episode = Episode.get(intent: intent)
		else {
			completion(INPlayMediaIntentResponse(code: .failure, userActivity: nil))
			return
		}
		
		guard container.type == .station
		else {
			completion(INPlayMediaIntentResponse(code: .failureUnknownMediaType, userActivity: nil))
			return
		}
		
		let response = INPlayMediaIntentResponse(code: .ready, userActivity: nil)
		response.nowPlayingInfo = episode.nowPlayInfo(forShortcut: true)
		completion(response)
	}
	
	func handle(intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
		let response = INPlayMediaIntentResponse(code: .handleInApp, userActivity: nil)
		completion(response)
	}
}
