//
//  AppDelegate.Shortcut.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import Intents
import os.log

extension AppDelegate {
	
	
	func handlePlayIntent(userActivity: NSUserActivity) -> Bool {
		guard userActivity.activityType == NSStringFromClass(INPlayMediaIntent.self),
			let mediaIntent = userActivity.interaction?.intent as? INPlayMediaIntent,
			let episode = Episode.get(intent: mediaIntent)
		else {
			return false
		}
		userActivity.addUserInfoEntries(from: ["LibraryItemContainerID": episode.id])
		return true
	}
	
	func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {
		
		guard let mediaIntent = intent as? INPlayMediaIntent,
			  let requestedContent = Episode.get(intent: mediaIntent)
		else {
			completionHandler(INPlayMediaIntentResponse(code: .failure, userActivity: nil))
			return
		}
		FMToolBar.shared.configToolBar(requestedContent)
		let response = INPlayMediaIntentResponse(code: .success, userActivity: nil)
		completionHandler(response)
	}
	
}

extension AppDelegate {
	
	func donateAll() {
		donateContinue()
		donateUpdatePodcast()
	}
	
	private func donateContinue() {
		donateIntent(intent: INIntent.continueIntent, id: INPlayMediaIntent.continuePlay)
	}
	
	private func donateUpdatePodcast() {
		donateIntent(intent: INIntent.updateIntent, id: INPlayMediaIntent.updatePodcast)
	}
	
	private func donateIntent(intent: INIntent, id: String) {
		let interaction = INInteraction(intent: intent, response: nil)
		interaction.groupIdentifier = id
		interaction.donate { (error) in
			if error != nil {
				guard let error = error as NSError? else { return }
				os_log("Could not donate interaction %@", error)
			} else {
				os_log("Play request interaction \(id) donation succeeded")
			}
		}
	}
	
	
}
