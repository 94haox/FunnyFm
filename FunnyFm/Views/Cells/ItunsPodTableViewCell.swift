//
//  ItunsPodTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/14.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class ItunsPodTableViewCell: UITableViewCell {

	@IBOutlet weak var authorLB: UILabel!
	@IBOutlet weak var titleLB: UILabel!
	@IBOutlet weak var postImageView: UIImageView!
	@IBOutlet weak var bgView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = .clear
		self.selectionStyle = .none;
		self.bgView.backgroundColor = CommonColor.cellbackgroud.color
    }
	
	func config(_ pod:iTunsPod) {
		self.titleLB.text = pod.trackName;
		self.authorLB.text = "最近更新：" + pod.releaseDate.subString(to: 10);
		self.postImageView.loadImage(url: pod.artworkUrl600)
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
