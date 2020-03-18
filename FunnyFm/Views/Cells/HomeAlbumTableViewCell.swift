//
//  HomeAlbumTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/6.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import pop
import Lottie

class HomeAlbumTableViewCell: UITableViewCell {

	@IBOutlet weak var shadowBgView: UIView!
	@IBOutlet weak var moreBtn: UIButton!
	@IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var updateLB: UILabel!
	private var tapClosure: (() -> Void)?
	private var tapLogoClosure: (() -> Void)?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
		self.shadowBgView.addShadow(ofColor: CommonColor.subtitle.color, radius: 10, offset: CGSize.init(width: 2, height: 2), opacity: 1)
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapLogoAction(_:)))
		self.logoImageView.addGestureRecognizer(tap)
        self.contentView.backgroundColor = CommonColor.white.color
    }
	
	func tranferNoParameterClosure(callbackEnclosure:@escaping (() -> Void)) {
		self.tapClosure = callbackEnclosure
	}
	
	func tapLogoGesAction(callbackEnclosure:@escaping (() -> Void)) {
		self.tapLogoClosure = callbackEnclosure
	}

	@IBAction func tapAction(_ sender: Any) {
		if self.tapClosure.isSome {
			self.tapClosure!()
		}
	}
	
	@objc func tapLogoAction(_ sender: Any) {
		if self.tapLogoClosure.isSome {
			self.tapLogoClosure!()
		}
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 
    }
    
    
    func configHomeCell(_ episode:Episode){
        self.titleLB.text = episode.title
        self.updateLB.text = episode.pubDate
		self.timeLB.text = FunnyFm.formatIntervalToString(NSInteger(episode.duration))
		if episode.podCoverUrl.length() > 0 {
			self.logoImageView.loadImage(url: episode.podCoverUrl)
		}else{
			self.logoImageView.loadImage(url: episode.coverUrl)
		}
    }
    
    func configCell(_ episode:Episode){
        self.titleLB.text = episode.title
		self.updateLB.text = episode.pubDate
		self.timeLB.text = FunnyFm.formatIntervalToString(NSInteger(episode.duration))
		if episode.coverUrl.length() > 0 {
			self.logoImageView.loadImage(url: episode.coverUrl)
		}else{
			self.logoImageView.loadImage(url: episode.podCoverUrl)
		}
    }
	
	func configNoDetailCell(_ episode:Episode){
		self.moreBtn.isHidden = true;
		self.configCell(episode)
	}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.contentView.alpha = 0.5
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.contentView.alpha = 1
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.contentView.alpha = 1
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle == .dark {
            self.shadowBgView.addShadow(ofColor: CommonColor.subtitle.color, radius: 10, offset: CGSize.init(width: 2, height: 2), opacity: 1)
        }else{
            self.shadowBgView.cleanShadow()
        }
    }
    
}
