//
//  NoteCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/2.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var descLB: UILabel!
	@IBOutlet weak var timeLB: UILabel!
	@IBOutlet weak var typeLB: UILabel!
	@IBOutlet weak var playBtn: UIButton!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
