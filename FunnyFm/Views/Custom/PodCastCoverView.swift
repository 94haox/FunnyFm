//
//  PodCastCoverView.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher

/// Pod详情顶部
class PodCastCoverView: UIView {
	
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
		self.bigCoverImageView.kf.setImage(with: resource)
		self.podCountLB.text = String(pod.count)
		self.timeLB.text = pod.update_time
		self.podNameLB.text = pod.name
		self.contentLB.text = pod.des
	}

	lazy var podNameLB: UILabel = {
		let lb = UILabel.init(text: "pod name")
		lb.textColor = .white
		lb.textAlignment = .center
		lb.font = p_bfont(16)
		return lb
	}()
	
	lazy var podCountLB: UILabel = {
		let lb = UILabel.init(text: "pod count")
		lb.textColor = .white
		lb.font = p_bfont(10)
		return lb
	}()
	
	lazy var timeLB: UILabel = {
		let lb = UILabel.init(text: "time ago")
		lb.textColor = .white
		lb.font = p_bfont(10)
		return lb
	}()
	
	lazy var podImageView: UIImageView = {
		let imageview = UIImageView.init(image: UIImage.init(named: "white_podcast"))
		return imageview
	}()
	
	lazy var logoImageView: UIImageView = {
		let imageview = UIImageView()
		imageview.cornerRadius = 5;
		return imageview
	}()
	
	lazy var timerImageView: UIImageView = {
		let imageview = UIImageView.init(image: UIImage.init(named: "white_timer"))
		return imageview
	}()
	
	lazy var bigCoverImageView: UIImageView = {
		let imageview = UIImageView.init()
		return imageview
	}()
	
	lazy var visulView: UIVisualEffectView = {
		let effect = UIBlurEffect.init(style: UIBlurEffect.Style.dark)
		let view = UIVisualEffectView.init(effect: effect)
		return view
	}()
	
	lazy var contentLB: UILabel = {
		let lb = UILabel.init(text: "content")
		lb.numberOfLines = 5
		lb.textColor = .white
		lb.textAlignment = .center
		lb.font = pfont(11)
		return lb
	}()
	
	lazy var cycelView: UIView = {
		let view = UIView.init()
		view.cornerRadius = 3.5
		view.backgroundColor = .white
		return view
	}()
	
	

}

extension PodCastCoverView {
	
	func dw_addConstraints(){
		self.backgroundColor = .white
		self.addSubview(self.bigCoverImageView)
		self.addSubview(self.visulView)
		self.addSubview(self.logoImageView)
		self.addSubview(self.cycelView)
		self.addSubview(self.timeLB)
		self.addSubview(self.podCountLB)
		self.addSubview(self.podNameLB)
		self.addSubview(self.podImageView)
		self.addSubview(self.timerImageView)
		self.addSubview(self.contentLB)
		
		
		self.bigCoverImageView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		self.visulView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		self.logoImageView.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.size.equalTo(CGSize.init(width: AdaptScale(55), height: AdaptScale(55)))
			make.top.equalToSuperview().offset(60)
		}
		
		self.cycelView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 7, height: 7))
			make.centerX.equalToSuperview()
			make.top.equalTo(self.logoImageView.snp.bottom).offset(16)
		}
		
		self.podNameLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.logoImageView.snp.bottom).offset(32)
			make.width.equalToSuperview().offset(-64)
			make.centerX.equalTo(self.logoImageView)
		}
		
		self.podImageView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 14, height: 14))
			make.right.equalTo(self.podCountLB.snp.left).offset(-5)
			make.centerY.equalTo(self.cycelView)
		}
		
		self.podCountLB.snp.makeConstraints { (make) in
			make.right.equalTo(self.cycelView.snp.left).offset(-14)
			make.centerY.equalTo(self.cycelView)
		}
		
		self.timerImageView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 14, height: 14))
			make.left.equalTo(self.cycelView.snp.right).offset(14)
			make.centerY.size.equalTo(self.cycelView)
		}
		
		self.timeLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.timerImageView.snp.right).offset(5)
			make.centerY.equalTo(self.timerImageView)
		}
		
		self.contentLB.snp.makeConstraints { (make) in
			make.width.equalToSuperview().offset(-48)
			make.centerX.equalToSuperview()
			make.top.equalTo(self.podNameLB.snp.bottom).offset(6)
		}
		
	}
	
}

