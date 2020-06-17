//
//  CountryCell.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
	@IBOutlet weak var flagImageView: UIImageView!
	
	@IBOutlet weak var nameLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
