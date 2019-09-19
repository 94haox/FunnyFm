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
	let progressBg = UIView()
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
		progressBg.backgroundColor = RGBA(255, 36, 83, 0.5)
		progressBg.frame = CGRect.init(x: 0, y: 0, width: 0, height: self.contentView.height)
		self.contentView.addSubview(progressBg)
		self.contentView.sendSubviewToBack(progressBg)
    }
	
	func config(task: DownloadTask){
		self.titleLB.text = task.episode!.title
		self.logoImageView.loadImage(url: task.episode!.coverUrl)
		
		
		let _ = NotificationCenter.default.rx.notification(Notification.Name.init("downloadprogress")).subscribe(onNext: {[weak self] (noti) in
			let url = noti.userInfo!["sourceUrl"] as! String
			self!.actionBtn.isSelected = true
			var frame = self!.progressBg.frame
			frame.size.width = self!.contentView.width * CGFloat((noti.userInfo!["progress"]! as! Double))
			UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
				self!.progressBg.frame = frame
			}, completion: nil)
		}, onError: nil, onCompleted: {
			
		}, onDisposed: nil)
		
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		
    }
    
}

extension DownloadTableViewCell: DownloadManagerDelegate{
	func downloadProgress(progress: Double, sourceUrl: String) {
		self.actionBtn.isSelected = true
		var frame = progressBg.frame
		frame.size.width = self.contentView.width * CGFloat(progress)
		UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
			self.progressBg.frame = frame
		}, completion: nil)
	}
	
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String) {
		self.actionBtn.isSelected = false
	}
	
	func didDownloadFailure(sourceUrl: String) {
		self.actionBtn.isSelected = false
	}
	

	
	
	
}
