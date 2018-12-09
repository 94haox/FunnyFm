//
//  PodDetailTopBar.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher


class PodDetailTopBar: UIView {
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.dw_addConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func config(_ pod: Pod){
		let resource = ImageResource.init(downloadURL: URL.init(string: pod.img)!)
		self.logoImageView.kf.setImage(with: resource)
		self.podCountLB.text = String(pod.count)
		self.timeLB.text = pod.update_time
		self.podNameLB.text = pod.name
	}
	
	
	lazy var podNameLB: UILabel = {
		let lb = UILabel.init(text: "pod name")
		lb.textColor = CommonColor.title.color
		lb.font = p_bfont(16)
		return lb
	}()
	
	lazy var podCountLB: UILabel = {
		let lb = UILabel.init(text: "pod count")
		lb.textColor = CommonColor.content.color
		lb.font = p_bfont(10)
		return lb
	}()
	
	lazy var timeLB: UILabel = {
		let lb = UILabel.init(text: "time ago")
		lb.textColor = CommonColor.content.color
		lb.font = p_bfont(10)
		return lb
	}()
	
	lazy var podImageView: UIImageView = {
		let imageview = UIImageView.init(image: UIImage.init(named: "pink_podcast"))
		return imageview
	}()
	
	lazy var logoImageView: UIImageView = {
		let imageview = UIImageView()
		imageview.cornerRadius = 5;
		return imageview
	}()
	
	lazy var timerImageView: UIImageView = {
		let imageview = UIImageView.init(image: UIImage.init(named: "pink_timer"))
		return imageview
	}()
}


extension PodDetailTopBar {
	
	func dw_addConstraints(){
		self.backgroundColor = .white
		self.cornerRadius = 20
		self.layer.masksToBounds = false
		let color = UIColor.init(hex: "E3BFC4")
		self.addShadow(ofColor: color, radius: 10, offset: CGSize.init(width: 0, height: 0), opacity: 1)
		self.addSubview(self.logoImageView)
		self.addSubview(self.timeLB)
		self.addSubview(self.podCountLB)
		self.addSubview(self.podNameLB)
		self.addSubview(self.podImageView)
		self.addSubview(self.timerImageView)
		
		
		self.logoImageView.snp.makeConstraints { (make) in
			make.left.equalTo(16)
			make.size.equalTo(CGSize.init(width: AdaptScale(45), height: AdaptScale(45)))
			make.centerY.equalToSuperview()
		}
		
		self.podNameLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.logoImageView.snp.right).offset(14)
			make.top.equalTo(self.logoImageView).offset(-4)
			make.right.equalToSuperview().offset(-16)
		}
		
		self.podImageView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 14, height: 14))
			make.bottom.equalTo(self.logoImageView).offset(-4)
			make.left.equalTo(self.podNameLB)
		}
		
		self.podCountLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.podImageView.snp.right).offset(5)
			make.centerY.equalTo(self.podImageView)
		}
		
		self.timerImageView.snp.makeConstraints { (make) in
			make.left.equalTo(self.podCountLB.snp.right).offset(25)
			make.centerY.size.equalTo(self.podImageView)
		}
		
		self.timeLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.timerImageView.snp.right).offset(5)
			make.centerY.equalTo(self.podImageView)
		}
		
	}
	
}
