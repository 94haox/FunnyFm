//
//  HistoryTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/19.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

	@IBOutlet weak var episodeLogoImgView: UIImageView!
	
	@IBOutlet weak var titleLB: UILabel!
	
	@IBOutlet weak var lastTimeLB: UILabel!
	
	@IBOutlet weak var progressBar: HistoryProgressBar!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
    }

	
	func config(episode: Episode){
		self.episodeLogoImgView.loadImage(url: episode.coverUrl)
		self.titleLB.text = episode.title
		let total = episode.duration
		let progress = DatabaseManager.qureyProgress(episodeId: episode.title)
		let differ = total - progress
		self.lastTimeLB.text = FunnyFm.formatIntervalToString(NSInteger(differ)) + " left"
		self.progressBar.update(with: progress/total)
	}
	
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
