//
//  OpmlTableViewCell.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/6.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class OpmlTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLB: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var titleLB: UILabel!
	var subscribeBlock: (() -> Void)?
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
    }
	
	func config(item: OPMLItem) {
		self.titleLB.text = item.title
		if let title = item.title, let firstLetter = title.first {
			nameLB.text = String([firstLetter]).uppercased()
		} else {
			nameLB.text = nil
		}
		item.htmlUrl
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func subscribeAction(_ sender: Any) {
		self.subscribeBlock?()
	}
}
