//
//  HistoryTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/19.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var episodeLogoImgView: UIImageView!
	
	@IBOutlet weak var titleLB: UILabel!
	
	@IBOutlet weak var lastTimeLB: UILabel!
	
	@IBOutlet weak var progressBar: HistoryProgressBar!
    
    var actionBlock: (()->Void)?
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
        self.contentView.backgroundColor = CommonColor.white.color
        self.playBtn.isHidden = true
    }

    @IBAction func playAction(_ sender: Any) {
        self.actionBlock?()
    }
    
    func config(playItem: Episode) {
        self.playBtn.isHidden = false
        self.config(episode: playItem)
    }
    
	func config(episode: Episode){
		self.episodeLogoImgView.loadImage(url: episode.coverUrl)
		self.titleLB.text = episode.title
		let total = episode.duration
		let progress = DatabaseManager.qureyProgress(trackUrl: episode.trackUrl)
		let differ = total - progress
		if progress == 0 {
			self.progressBar.isHidden = true
			self.lastTimeLB.text = "尚未播放".localized
		}else if differ > 10{
			self.progressBar.isHidden = false
			self.lastTimeLB.text = Date.formatIntervalToHMS(NSInteger(differ)) + " " + "未播".localized
		}else{
			self.lastTimeLB.text = "Finsh"
		}
		self.progressBar.update(with: progress/total)
	}
	
	
	
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
