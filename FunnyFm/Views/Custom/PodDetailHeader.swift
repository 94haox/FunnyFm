//
//  PodDetailHeader.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Kingfisher

class PodDetailHeader: UIView {

	var podImageView: UIImageView!
	
	var podNameLB: UILabel!
	
	var podAuthorLB: UILabel!
	
	var countLB: UILabel!
	
	var pod: iTunsPod!
	
	var subBtn: UIButton!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubviews()
	}
	
	func config(model:iTunsPod){
		self.pod = model
		self.podImageView.kf.setImage(with: URL.init(string: self.pod.artworkUrl600)!) {[weak self] result in}
		self.podNameLB.text = model.trackName
		self.podAuthorLB.text = model.podAuthor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
		
		
	}
	
	func addSubviews(){
//		self.podBackgroundView = UIView.init()
//		self.podBackgroundView.cornerRadius = 15
//		self.view.addSubview(self.podBackgroundView)
		
		self.podImageView = UIImageView.init()
		self.podImageView.cornerRadius = 15;
		self.addSubview(self.podImageView)
		
		self.podNameLB = UILabel.init(text: self.pod.trackName)
		self.podNameLB.textColor = CommonColor.title.color
		self.podNameLB.font = p_bfont(18)
		
		self.podAuthorLB = UILabel.init(text: self.pod.podAuthor)
		self.podAuthorLB.textColor = CommonColor.content.color
		self.podAuthorLB.font = p_bfont(15)
		
		self.countLB = UILabel.init(text: self.pod.releaseDate)
		self.countLB.textColor = CommonColor.content.color
		self.countLB.font = p_bfont(12)
		
		self.subBtn = UIButton.init(type: .custom)
		self.subBtn.setTitle("已订阅", for: .normal)
		self.subBtn.setTitleColor(.white, for: .normal)
		self.subBtn.setTitle("订阅", for: .selected)
		self.subBtn.setTitleColor(.white, for: .selected)
		
	}

}


