//
//  DownloadTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/17.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DownloadTableViewCell: UITableViewCell {

	@IBOutlet weak var actionBtn: UIButton!
	@IBOutlet weak var addTimeLB: UILabel!
	@IBOutlet weak var titleLB: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	var task: DownloadTask?
	let progressBg = UIView()
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
		progressBg.backgroundColor = UIColor.init(hex: "f2faff")
		progressBg.frame = CGRect.init(x: 0, y: 0, width: 0, height: self.contentView.height)
		self.contentView.addSubview(progressBg)
		self.contentView.sendSubviewToBack(progressBg)
		NotificationCenter.default.addObserver(self, selector: #selector(updateProgress(noti:)), name: Notification.downloadProgressNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(didDownloadFailure(noti:)), name: Notification.downloadFailureNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(didDownloadSuccess(noti:)), name: Notification.downloadSuccessNotification, object: nil)
    }
	
	func config(task: DownloadTask){
		self.titleLB.text = task.episode!.title
		self.addTimeLB.text = task.addDate
		self.logoImageView.loadImage(url: task.episode!.coverUrl)
		self.task = task
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	@IBAction func btnAction(_ sender: Any) {
		
		if self.actionBtn.isSelected {
			if self.task.isNone {
				return
			}
			DownloadManager.shared.stopDownload(self.task!)
		}
		
	}
	
}

extension DownloadTableViewCell{
	
	@objc func updateProgress(noti: Notification){
		if !isCurrentTask(noti: noti) {
			return
		}
		let param = noti.object as! [String: Any]
		self.actionBtn.isSelected = true
		var frame = self.progressBg.frame
		frame.size.width = self.contentView.width * CGFloat((param["progress"]! as! Double))
		UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
			self.progressBg.frame = frame
		}, completion: nil)
	}
	
	@objc func didDownloadSuccess(noti: Notification) {
		if !isCurrentTask(noti: noti) {
			return
		}
		self.actionBtn.isSelected = false
	}
	
	
	
	@objc func didDownloadFailure(noti: Notification) {
		if !isCurrentTask(noti: noti) {
			return
		}
		self.actionBtn.isSelected = false
	}
	
	func isCurrentTask(noti: Notification) -> Bool{
		if noti.object.isNone {
			return false
		}
		let param = noti.object as! [String: Any]
		let url = param["sourceUrl"] as! String
		
		if self.task.isNone {
			return false
		}
		
		if url != self.task!.episode!.trackUrl {
			return false
		}
		
		return true
	}
	
	
	
}
