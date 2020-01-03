//
//  MessageCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var moreBtn: UIButton!
	@IBOutlet weak var dateLB: UILabel!
	@IBOutlet weak var contentLB: UILabel!
	@IBOutlet weak var titleLB: UILabel!
	var moreClosure : (()->Void)?
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = .white
		self.cornerRadius = 8
		self.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.zero, opacity:1)
    }
	
	func config(msg: Message){
		self.dateLB.text = msg.pubDate;
		self.contentLB.text = msg.content;
		self.titleLB.text = msg.title
	}
	
	@IBAction func moreAction(_ sender: Any) {
		if moreClosure.isSome {
			moreClosure?()
		}
	}
	
}
