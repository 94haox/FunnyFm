//
//  PodcastInfoView.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/8.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class PodcastInfoView: UIView {

	var podImageView: UIImageView = UIImageView.init()
	var podNameLB: UILabel = UILabel.init()
	var pageControl: UIPageControl = UIPageControl.init(frame: CGRect.zero)
	var desLB: UILabel = UILabel.init()
	var sourceLB: UILabel = UILabel.init()
	var authorLB: UILabel = UILabel.init()
	var mainScrollView: UIScrollView = UIScrollView.init()
	var countLB: UILabel = UILabel.init()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
		self.dw_addConstraints()
	}
	
	func config(pod: iTunsPod){
		self.podNameLB.text = pod.trackName
		self.authorLB.text = pod.podAuthor
		self.desLB.text = pod.podDes
		if self.podImageView.image.isNone {
			self.podImageView.loadImage(url: pod.artworkUrl600)
		}
		self.countLB.text = "Episodes: " + pod.trackCount
		
		if pod.podDes.length() > 0 {
			self.mainScrollView.contentSize = CGSize.init(width: kScreenWidth*2, height: 0)
			self.pageControl.numberOfPages = 2
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension PodcastInfoView : UIScrollViewDelegate{
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		if offset.x >= kScreenWidth {
			self.pageControl.currentPage = 1
		}else{
			self.pageControl.currentPage = 0
		}
	}
	
	func dw_addConstraints(){
		
		self.mainScrollView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		self.podImageView.snp.makeConstraints { (make) in
			make.top.equalTo(self).offset(44.auto());
			make.centerX.equalTo(self.mainScrollView)
			make.size.equalTo(CGSize.init(width: 100.auto(), height: 100.auto()));
		}
		
		self.podNameLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.podImageView.snp_bottom).offset(5);
			make.width.equalToSuperview().offset(-100.auto())
			make.centerX.equalToSuperview();
		}
		
		self.authorLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.podNameLB.snp.bottom).offset(12)
			make.centerX.equalToSuperview();
		}
		
		self.sourceLB.snp.makeConstraints { (make) in
			make.width.left.equalTo(self.podNameLB);
			make.top.equalTo(self.authorLB.snp.bottom).offset(12)
		}
		
		self.desLB.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.mainScrollView).offset(kScreenWidth);
			make.centerY.equalToSuperview()
			make.width.equalTo(self).offset(-40.auto());
		}
		
		self.countLB.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.desLB)
			make.top.equalTo(self.desLB.snp_bottom).offset(8)
		}
		
		self.pageControl.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-2)
			
		}
	
	}
	
	func setupUI(){
		
		self.mainScrollView.isPagingEnabled = true
		self.mainScrollView.showsHorizontalScrollIndicator = false
		self.mainScrollView.delegate = self
		self.addSubview(self.mainScrollView)
		
		self.pageControl.currentPageIndicatorTintColor = CommonColor.mainRed.color
		self.pageControl.pageIndicatorTintColor = .lightGray
		self.pageControl.numberOfPages = 1;
		self.pageControl.currentPage = 0
		self.addSubview(self.pageControl)
		
		self.podImageView.cornerRadius = 15
		self.mainScrollView.addSubview(self.podImageView)
		
		self.podNameLB.font = h_bfont(22);
		self.podNameLB.textColor = CommonColor.title.color
		self.podNameLB.numberOfLines = 2;
		self.podNameLB.textAlignment = .center;
		self.mainScrollView.addSubview(self.podNameLB)
		
		self.desLB.font = hfont(14);
		self.desLB.numberOfLines = 4;
		self.desLB.textColor = CommonColor.content.color
		self.desLB.textAlignment = .center;
		self.mainScrollView.addSubview(self.desLB)
		
		self.sourceLB.font = hfont(14);
		self.sourceLB.textColor = CommonColor.content.color
		self.mainScrollView.addSubview(self.sourceLB)
		
		self.authorLB.font = hfont(14)
		self.authorLB.textColor = CommonColor.content.color
		self.mainScrollView.addSubview(self.authorLB)
		
		self.countLB.font = hfont(14)
		self.countLB.textColor = CommonColor.content.color
		self.mainScrollView.addSubview(self.countLB)
		
		
	}
}
