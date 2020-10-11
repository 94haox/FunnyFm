//
//  IntentUtil.swift
//  FunnyIntent
//
//  Created by Tao on 2020/10/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import Intents

protocol MediaItemConvertible {
	var mediaItem: INMediaItem { get }
}

extension Episode: MediaItemConvertible {
	
	var mediaItem: INMediaItem {
		return INMediaItem(identifier: id,
						   title: title,
						   type: .podcastEpisode,
						   artwork: INImage(url: URL(string: podCoverUrl)!),
						   artist: author)
	}
	
	var intent: INPlayMediaIntent {
		let mediaItems = [mediaItem]
		let intent = INPlayMediaIntent(mediaItems: mediaItems,
									   mediaContainer: mediaItem,
									   playShuffled: false,
									   playbackRepeatMode: .none,
									   resumePlayback: false)
		intent.shortcutAvailability = .sleepPodcasts
		
//		if let track = tracks?.first, tracks?.count == 1 {
//            intent.suggestedInvocationPhrase = "Play \(track.title)"
			intent.suggestedInvocationPhrase = "Play \(title)"
//		}
		
		return intent
	}
	
}

