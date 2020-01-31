//
//  DiscoverPodcastViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2020/1/31.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class DiscoverPodcastViewCell: UICollectionViewCell {
	
	var imageView: UIImageView! = UIImageView.init()
	
	var titleLB: UILabel! = UILabel.init(text: "title")
	
	var subtitleLB: UILabel! = UILabel.init(text: "subtitle")

    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	func config(podcast: iTunsPod) {
		self.titleLB.text = podcast.trackName
		self.subtitleLB.text = podcast.podAuthor
		self.imageView.loadImage(url: podcast.artworkUrl600)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension DiscoverPodcastViewCell {
	
	func setupUI(){
		self.imageView.cornerRadius = 8
		self.titleLB.numberOfLines = 2
		self.titleLB.textColor = CommonColor.title.color
		self.titleLB.font = p_bfont(fontsize2)
		self.subtitleLB.font = pfont(fontsize0)
		self.subtitleLB.textColor = CommonColor.content.color
		self.addSubview(self.imageView)
		self.addSubview(self.subtitleLB)
		self.addSubview(self.titleLB)
		
		self.imageView.snp.makeConstraints { (make) in
			make.left.top.width.equalToSuperview()
			make.height.equalTo(self.snp_width)
		}
		
		self.titleLB.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(6.auto())
			make.right.equalToSuperview().offset(-6.auto())
			make.top.equalTo(self.imageView.snp_bottom).offset(12.auto())
		}
		
		self.subtitleLB.snp.makeConstraints { (make) in
			make.left.right.equalTo(self.titleLB)
			make.top.equalTo(self.titleLB.snp_bottom).offset(8.auto())
		}
	}
	
}
