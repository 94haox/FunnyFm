//
//  PodListCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class PodListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var updateTimeLB: UILabel!
    
	@IBOutlet weak var imageBg: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = UIColor.clear
		self.logoImageView.cornerRadius = 30.0
		self.imageBg.layer.masksToBounds = false
		self.imageBg.layer.borderWidth = CGFloat.leastNormalMagnitude
		self.imageBg.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        self.titleLB.textColor = CommonColor.title.color
        self.updateTimeLB.textColor = CommonColor.subtitle.color
        // Initialization code
    }
    
    func configCell(_ pod: iTunsPod){
        self.logoImageView.loadImage(url: pod.artworkUrl600)
        self.titleLB.text = pod.trackName
        self.updateTimeLB.text = self.fromStringToDate(string: pod.releaseDate).dateString()
    }
	
	func fromStringToDate(string :String) ->Date{
		let dformatter = DateFormatter()
		dformatter.dateFormat = "yyyy-MM-dd"
		let date = dformatter.date(from: string.subString(to: 10))
		return date!
	}


}
