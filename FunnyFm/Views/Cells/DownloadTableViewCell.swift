//
//  DownloadTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/17.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Tiercel

class DownloadTableViewCell: UITableViewCell {

	@IBOutlet weak var actionBtn: UIButton!
	@IBOutlet weak var addTimeLB: UILabel!
	@IBOutlet weak var titleLB: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	var task: DownloadTask?
	let progressBg = UIView()
	var deleteClosure : (()->Void)?
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.contentView.backgroundColor = CommonColor.white.color
		self.selectionStyle = .none
        progressBg.backgroundColor = CommonColor.progress.color
		progressBg.frame = CGRect.init(x: 0, y: 0, width: 0, height: 85)
		self.contentView.addSubview(progressBg)
		self.contentView.sendSubviewToBack(progressBg)
		self.actionBtn.addShadow(ofColor: CommonColor.cellbackgroud.color, radius: 5, offset: CGSize.zero, opacity: 1)
        self.actionBtn.backgroundColor = R.color.button_background_disabled()
        self.actionBtn.setImage(R.image.cancel()?.tintImage, for: .selected)
        self.actionBtn.setImage(R.image.trash()?.tintImage, for: .normal)
        self.actionBtn.tintColor = R.color.mainRed();
    }
	
	func config(task: DownloadTask){
		DownloadManager.shared.delegate = self
		self.actionBtn.isSelected = true
		self.titleLB.text = task.episode?.title
		self.addTimeLB.text = task.startDateString
		self.logoImageView.loadImage(url: task.episode!.coverUrl)
		self.task = task
		self.progressBg.isHidden = false
	}
	
	func config(episode: Episode) {
		self.task = nil
		self.actionBtn.isSelected = false
		self.titleLB.text = episode.title
		if episode.downloadSize.length() < 1 {
			self.addTimeLB.text = Date.formatIntervalToString(NSInteger(episode.duration))
		}else{
			self.addTimeLB.text = episode.downloadSize
		}
		self.logoImageView.loadImage(url: episode.coverUrl)
		self.progressBg.frame = CGRect.init(x: 0, y: 0, width: 0, height: 85)
		self.progressBg.isHidden = true
	}
	

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	@IBAction func btnAction(_ sender: Any) {
		
		if self.actionBtn.isSelected {
            guard self.task.isSome else {
                return
            }
            guard let episode = task!.episode else {
                return
            }
            DownloadManager.shared.stopDownload(episode: episode)
			return
		}
        self.deleteClosure?()
		
	}
	
}

extension DownloadTableViewCell: DownloadManagerDelegate{
	
	func downloadProgress(progress: Double, sourceUrl: String) {
		if !isCurrentTask(sourceUrl){
			return
		}
		
		self.actionBtn.isSelected = true
		var frame = self.progressBg.frame
		DispatchQueue.main.async {
			frame.size.width = self.contentView.width * CGFloat(progress)
			UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
				self.progressBg.frame = frame
			}, completion: nil )
		}
	}
	
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String) {
		if !isCurrentTask(sourceUrl) {
			return
		}
		DispatchQueue.main.async {
			self.actionBtn.isSelected = false
		}
	}
	
	func didDownloadFailure(sourceUrl: String) {
		if !isCurrentTask(sourceUrl) {
			return
		}
		self.actionBtn.isSelected = false
	}
	
	
	func isCurrentTask(_ sourceUrl: String) -> Bool{
		
		if self.task.isNone {
			return false
		}
		
		if sourceUrl != self.task!.episode!.trackUrl {
			return false
		}
		
		return true
	}
	
	
	
}
