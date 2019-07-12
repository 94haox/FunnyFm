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
	
	var updateLB: UILabel!
	
	var pod: iTunsPod!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubviews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func addSubviews(){
//		self.podBackgroundView = UIView.init()
//		self.podBackgroundView.cornerRadius = 15
//		self.view.addSubview(self.podBackgroundView)
		
		self.podImageView = UIImageView.init()
		self.podImageView.kf.setImage(with: URL.init(string: self.pod.artworkUrl600)!) {[weak self] result in
//			switch result {
//			case .success(let value):
//				self.podBackgroundView.addShadow(ofColor: value.image.mostColor(), radius: 0, offset: CGSize.init(width: 5, height: 5), opacity: 0)
//			case .failure(let error):
//				print("Error: \(error)")
//			}
		}
		self.podImageView.cornerRadius = 15;
		self.addSubview(self.podImageView)
		
		self.podNameLB = UILabel.init(text: self.pod.trackName)
		self.podNameLB.textColor = CommonColor.title.color
		self.podNameLB.font = p_bfont(18)
		
		self.podAuthorLB = UILabel.init(text: self.pod.podAuthor)
		self.podAuthorLB.textColor = CommonColor.content.color
		self.podAuthorLB.font = p_bfont(15)
		
		self.updateLB = UILabel.init(text: self.pod.releaseDate)
		self.updateLB.textColor = CommonColor.content.color
		self.updateLB.font = p_bfont(12)
		
	}

}


