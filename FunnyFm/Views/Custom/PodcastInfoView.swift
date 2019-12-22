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
	var authorLB: UILabel = UILabel.init()
	var mainScrollView: UIScrollView = UIScrollView.init()
	var countLB: UILabel = UILabel.init()
	var subBtn: UIButton!
	var subscribeClosure: (()->Void)?
	var stackView: UIStackView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
		self.dw_addConstraints()
	}
	
	@objc func subscribtionAction(){
		if subscribeClosure.isSome {
			subscribeClosure!()
		}
	}
	
	func config(pod: iTunsPod){
		
		self.podNameLB.text = pod.trackName
		self.authorLB.text = pod.podAuthor
		self.countLB.text = "by-" + pod.podAuthor
		self.desLB.text = pod.podDes
		if self.podImageView.image.isNone {
			self.podImageView.loadImage(url: pod.artworkUrl600)
		}
		
		if pod.podAuthor.length() < 1 {
			self.countLB.text = "by-" + pod.trackName
			self.authorLB.text = pod.trackName
		}
		
		
		if pod.podDes.length() > 0 {
			self.mainScrollView.contentSize = CGSize.init(width: kScreenWidth*2, height: 0)
			self.pageControl.numberOfPages = 2
		}
		
		if DatabaseManager.getPodcast(feedUrl: pod.feedUrl).isSome {
			self.subBtn.isSelected = false
		}else{
			self.subBtn.isSelected = true
			self.subBtn.backgroundColor = .white
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
			make.size.equalTo(CGSize.init(width: 100, height: 100));
		}
		
		self.podNameLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.podImageView.snp_bottom).offset(8);
			make.width.equalToSuperview().offset(-20.auto())
			make.centerX.equalToSuperview();
		}
		
		self.authorLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.podNameLB.snp.bottom).offset(5)
			make.centerX.equalToSuperview();
		}
		
		self.stackView.snp_makeConstraints { (make) in
			make.centerX.equalTo(self.mainScrollView).offset(kScreenWidth);
			make.centerY.equalToSuperview().offset(-9)
			if UIDevice.current.systemVersion.hasPrefix("13.") {
				make.width.equalTo(self).offset(-50.auto())
			}else{
				make.width.equalTo(self).offset(-70.auto())
			}
		}
		
		self.pageControl.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self.subBtn.snp_top).offset(-8)
			make.height.equalTo(10)
		}
		
		self.subBtn.snp.makeConstraints { (make) in
			make.width.equalTo(70.auto())
			make.height.equalTo(30)
			make.centerX.equalToSuperview()
			make.bottom.equalTo(self).offset(-8)
		}
	
	}
	
	func setupUI(){
		
		self.mainScrollView.isPagingEnabled = true
		self.mainScrollView.showsHorizontalScrollIndicator = false
		self.mainScrollView.delegate = self
		self.addSubview(self.mainScrollView)
		
		self.pageControl.currentPageIndicatorTintColor = CommonColor.mainRed.color
		self.pageControl.pageIndicatorTintColor = UIColor.init(hex: "c1bdbe")
		self.pageControl.numberOfPages = 1;
		self.pageControl.currentPage = 0
		self.addSubview(self.pageControl)
		
		self.podImageView.cornerRadius = 15
		self.mainScrollView.addSubview(self.podImageView)
		
		self.podNameLB.font = h_bfont(18);
		self.podNameLB.textColor = CommonColor.title.color
		self.podNameLB.numberOfLines = 1;
		self.podNameLB.textAlignment = .center;
		self.mainScrollView.addSubview(self.podNameLB)
		
		self.desLB.font = hfont(12);
		self.desLB.numberOfLines = 7;
		self.desLB.textColor = CommonColor.content.color
		self.desLB.textAlignment = .center;
		
		self.countLB.font = hfont(12)
		self.countLB.textAlignment = .center
		self.countLB.textColor = CommonColor.content.color
		
		self.authorLB.font = hfont(12)
		self.authorLB.textColor = CommonColor.content.color
		self.mainScrollView.addSubview(self.authorLB)

		self.stackView = UIStackView.init(arrangedSubviews: [self.desLB, self.countLB], axis: .vertical)
		self.mainScrollView.addSubview(self.stackView)
		
		self.subBtn = UIButton.init(type: .custom)
		self.subBtn.setTitle("已订阅".localized, for: .normal)
		self.subBtn.setTitleColor(.white, for: .normal)
		self.subBtn.setTitle("订阅".localized, for: .selected)
		self.subBtn.setTitleColor(CommonColor.mainRed.color, for: .selected)
		self.subBtn.backgroundColor = CommonColor.mainRed.color
		self.subBtn.titleLabel?.font = p_bfont(10.auto())
		self.subBtn.borderWidth = 1;
		self.subBtn.borderColor = CommonColor.mainRed.color
		self.subBtn.cornerRadius = 5
		self.subBtn.addTarget(self, action: #selector(subscribtionAction), for: .touchUpInside)
		self.addSubview(self.subBtn)
	}
}
