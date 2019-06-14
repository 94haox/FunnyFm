//
//  ItunsPodTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/14.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Kingfisher

class ItunsPodTableViewCell: UITableViewCell {

	@IBOutlet weak var authorLB: UILabel!
	@IBOutlet weak var titleLB: UILabel!
	@IBOutlet weak var postImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = .clear
		self.selectionStyle = .none;
    }
	
	func config(_ pod:iTunsPod) {
		self.titleLB.text = pod.trackName;
		self.authorLB.text = "最近更新：" + pod.releaseDate.subString(to: 10);
		let resource = ImageResource.init(downloadURL: URL.init(string: pod.artworkUrl600)!)
		self.postImageView.kf.setImage(with: resource)
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
