//
//  CloudSyncCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class CloudSyncCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var podImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.cornerRadius = 5;
    }
	
	func config(pod: iTunsPod) {
		self.podImageView.loadImage(url: pod.artworkUrl600)
	}

}
