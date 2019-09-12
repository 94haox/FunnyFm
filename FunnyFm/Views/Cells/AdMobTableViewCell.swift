//
//  AdMobTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/29.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdMobTableViewCell: UITableViewCell {

	@IBOutlet weak var adverLB: UILabel!
	@IBOutlet weak var priceLB: UILabel!
	@IBOutlet weak var titleLB: UILabel!
	@IBOutlet weak var mediaView: GADMediaView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	func config(nativeAd: GADUnifiedNativeAd){
		self.titleLB.text = nativeAd.headline
		self.priceLB.text = nativeAd.body
		self.adverLB.text = nativeAd.advertiser
		self.mediaView.mediaContent = nativeAd.mediaContent
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
