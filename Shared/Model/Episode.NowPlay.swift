//
//  Episode.NowPlay.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import Intents

extension Episode {
	
	func nowPlayInfo(forShortcut: Bool) -> [String: Any] {
		var nowPlayingInfo: [String: Any] = [MPMediaItemPropertyTitle: title,
											 MPMediaItemPropertyMediaType: MPMediaType.anyAudio.rawValue,
											 MPMediaItemPropertyAlbumTitle: author,
											 MPMediaItemPropertyPlaybackDuration: NSNumber(value: duration)]
		
		if forShortcut {
			nowPlayingInfo[MPMediaItemPropertyArtwork] = INImage(url: URL(string: podCoverUrl)!)
		} else {
			nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(boundsSize: CGSize.init(width: 100, height: 100), requestHandler: { (size) -> UIImage in
				if let url = URL.init(string: coverUrl) {
					do {
						let data = try Data(contentsOf: url)
						let image = UIImage(data: data)
						if image == nil {
							return UIImage.init(named: "ImagePlaceHolder")!
						}
						return image!
					}catch{
						return UIImage.init(named: "ImagePlaceHolder")!
					}
				}
				return UIImage.init(named: "ImagePlaceHolder")!
			})
		}
		return nowPlayingInfo
	}
	
	
}
