//
//  NoteCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/2.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var youImage: UIImageView!
	@IBOutlet weak var descLB: UILabel!
	@IBOutlet weak var timeLB: UILabel!
	@IBOutlet weak var typeLB: UILabel!
	@IBOutlet weak var playBtn: UIButton!
	override func awakeFromNib() {
        super.awakeFromNib()
		self.cornerRadius = 15.auto()
        self.backgroundColor = CommonColor.whiteBackgroud.color
		self.addShadow(ofColor: CommonColor.background.color, radius: 15, offset: CGSize.zero, opacity: 1)
    }
	
	func config(note: Note){
		self.descLB.text = note.noteDesc
		self.timeLB.text = FunnyFm.formatIntervalToMM(note.noteMoment)
		
		self.youImage.isHidden =  !(note.userId == UserCenter.shared.userId)
		
		switch note.noteType {
			case 1:
				self.typeLB.text = "✍🏻"
			case 2:
				self.typeLB.text = "👏🏻"
			case 3:
				self.typeLB.text = "🤔"
			default:
			break
		}
	}

}
