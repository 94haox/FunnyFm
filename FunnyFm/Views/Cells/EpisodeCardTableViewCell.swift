//
//  EpisodeCardTableViewCell.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/5/27.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class EpisodeCardTableViewCell: UITableViewCell {
	
	@IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var sumryLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    var tapLogoClosure: (() -> Void)?
    var _episode: Episode?

    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
		let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(logoTapAction))
		self.iconImageView.addGestureRecognizer(tapGes)
		self.iconImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		
        // Configure the view for the selected state
    }
	
	func configHomeCell(_ episode: Episode){
		_episode = episode;
		self.titleLB.text = episode.title
		self.sumryLB.text = episode.intro
		self.timeLB.text = FunnyFm.formatIntervalToString(NSInteger(episode.duration))
		if episode.podCoverUrl.length() > 0 {
			self.iconImageView.loadImage(url: episode.podCoverUrl)
		}else{
			self.iconImageView.loadImage(url: episode.coverUrl)
		}
		
		guard let _ = FMPlayerManager.shared.currentModel else {
			self.playBtn.isSelected = false
			return
		}
		
		self.playBtn.isSelected = episode.trackUrl == FMPlayerManager.shared.currentModel!.trackUrl && FMPlayerManager.shared.isPlay
	}
	
    @objc func logoTapAction() {
        if tapLogoClosure.isSome {
            tapLogoClosure?()
        }
    }
	
	@IBAction func playAction(_ sender: UIButton) {
		guard let episode = _episode else {
			return
		}
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			FMToolBar.shared.configToolBarAtHome(episode)
		}else{
			FMToolBar.shared.toobarPause()
		}
		
	}
    
}
