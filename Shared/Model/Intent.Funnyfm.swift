//
//  Intent.Funnyfm.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import Intents

extension INIntent {
	
	static var continueIntent: INPlayMediaIntent {
		let item = INMediaItem(identifier: INPlayMediaIntent.continuePlay,
							   title: "继续播放",
							   type: .podcastEpisode,
							   artwork: INImage(named: "AppIcon-blue"),
							   artist: "趣博客")
		let intent = INPlayMediaIntent(mediaItems: [item],
									   mediaContainer: item,
									   playShuffled: false,
									   playbackRepeatMode: .none,
									   resumePlayback: false)
		intent.shortcutAvailability = .sleepPodcasts
		intent.suggestedInvocationPhrase = "继续播放"
		return intent
	}
	
	static var updateIntent: INPlayMediaIntent {
		let item = INMediaItem(identifier: INPlayMediaIntent.updatePodcast,
							   title: "获取最新单集",
							   type: .podcastEpisode,
							   artwork: INImage(named: "AppIcon-blue"),
							   artist: "趣博客")
		let intent = INPlayMediaIntent(mediaItems: [item],
									   mediaContainer: item,
									   playShuffled: false,
									   playbackRepeatMode: .none,
									   resumePlayback: false)
		intent.shortcutAvailability = .sleepPodcasts
		intent.suggestedInvocationPhrase = "获取最新单集"
		return intent
	}
	
	
}

extension INIntent {
	static let updatePodcast = "funnyfm_intent_update_podcast"
	static let continuePlay = "funnyfm_intent_continue"
}
