//
//  EpisodeInfoViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/28.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class EpisodeInfoViewController: UIViewController {

	var scrollView: UIScrollView = UIScrollView()
	
	var containerView: UIView = UIView()
	
	var episodeImageView: UIImageView = UIImageView.init()
	
	var titleLB: UILabel!
	
	var authorLB: UILabel!
	
	var playBtn: UIButton = UIButton.init(type: .custom)
	
	var downloadBtn: UIButton = UIButton.init(type: .custom)
	
	var desTextView: UITextView = UITextView.init()
	
	var episode: Episode!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dw_addSubviews()
		self.dw_addConstrants()
		
		self.config(content: episode)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		FMToolBar.shared.shrink()
	}
	
}

extension EpisodeInfoViewController {
	
	func dw_addConstrants(){
		self.view.addSubview(self.scrollView)
		self.scrollView.addSubview(self.containerView)
		self.containerView.addSubview(self.episodeImageView)
		self.containerView.addSubview(self.titleLB)
		self.containerView.addSubview(self.authorLB)
		self.containerView.addSubview(self.playBtn)
		self.containerView.addSubview(self.downloadBtn)
		self.containerView.addSubview(self.desTextView)
		
		
		
		self.scrollView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		self.containerView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
		}
		
		self.episodeImageView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(16)
			make.top.equalToSuperview().offset(44)
			make.size.equalTo(CGSize.init(width: 65, height: 65))
		}
		
		self.titleLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.episodeImageView.snp.right).offset(12)
			make.right.equalToSuperview().offset(-30)
			make.top.equalTo(self.episodeImageView)
		}
		
		self.authorLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.titleLB);
			make.bottom.equalTo(self.episodeImageView)
		}
		
		self.playBtn.snp.makeConstraints { (make) in
			make.left.equalTo(self.episodeImageView)
			make.top.equalTo(self.episodeImageView.snp.bottom).offset(16)
			make.right.equalTo(self.downloadBtn.snp_left).offset(-24)
			make.height.equalTo(40)
		}
		
		self.downloadBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.playBtn)
			make.right.equalToSuperview().offset(-16)
			make.height.equalTo(self.playBtn)
			make.width.equalTo(50)
		}
		
		self.desTextView.snp.makeConstraints { (make) in
			make.top.equalTo(self.playBtn.snp.bottom).offset(24)
			make.leading.equalTo(self.containerView).offset(16);
			make.trailing.equalTo(self.containerView).offset(-16);
		}
		
		self.containerView.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.desTextView).offset(50)
		}
		
		self.view.layoutIfNeeded()
		
//		let path = UIBezierPath.init(roundedRect: self.scrollView.bounds, byRoundingCorners: [.topLeft  ,.topRight], cornerRadii: CGSize.init(width: 15, height: 15))
//		let maskLayer = CAShapeLayer.init()
//		maskLayer.path = path.cgPath
//		maskLayer.frame = self.scrollView.bounds
//		self.scrollView.layer.mask = maskLayer
	}
	
	func dw_addSubviews(){
		
		self.desTextView.isEditable = false
		self.desTextView.bounces = false
		self.desTextView.dataDetectorTypes = .all
		
		self.scrollView.backgroundColor = .white
		self.episodeImageView.cornerRadius = 5;
		
		self.titleLB = UILabel.init(text: self.episode.title)
		self.titleLB.textColor = CommonColor.title.color
		self.titleLB.font = p_bfont(14)
		self.titleLB.numberOfLines = 0;
		
		self.authorLB = UILabel.init(text: self.episode.author)
		self.authorLB.textColor = CommonColor.content.color
		self.authorLB.font = p_bfont(10)
		
		self.playBtn.backgroundColor = CommonColor.mainRed.color
		self.playBtn.cornerRadius = 8
		
		self.downloadBtn.backgroundColor = .white
		self.downloadBtn.setImage(UIImage.init(named: "download_icon"), for: .normal)
		self.downloadBtn.cornerRadius = 8
		self.downloadBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
		

		self.desTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: CommonColor.mainRed.color]
		self.desTextView.showsVerticalScrollIndicator = false
	}
	
}

extension EpisodeInfoViewController {
	
	func config(content: Episode) {
		
		self.episodeImageView.loadImage(url: episode.coverUrl)
		self.titleLB.text = episode.title
		self.authorLB.text = episode.author
		
		guard self.episode.intro.contains("<") else {
			self.episode.intro = self.episode.intro.replacingOccurrences(of: "。", with: "。\n")
			let content = NSAttributedString.init(string: self.episode.intro, attributes: [NSAttributedString.Key.font : pfont(14), NSAttributedString.Key.foregroundColor: CommonColor.content.color])
			self.desTextView.attributedText = content
			self.desTextView.snp.remakeConstraints { (make) in
				make.leading.equalTo(self.containerView).offset(16);
				make.trailing.equalTo(self.containerView).offset(-16);
				make.top.equalTo(self.playBtn.snp.bottom).offset(24)
				make.height.equalTo(self.desTextView.contentSize.height)
			}
			self.view.layoutIfNeeded()
			return
		}
		
		do{
			let srtData = self.episode.intro.data(using: String.Encoding.unicode, allowLossyConversion: true)!
			let attrStr = try NSMutableAttributedString(data: srtData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
			attrStr.enumerateAttributes(in: NSRange.init(location: 0, length: attrStr.length), options: NSAttributedString.EnumerationOptions.reverse) {[weak attrStr] (attr, range, lef) in
				attr.keys.forEach({ (key) in
					if key == .font {
						let font = attr[key] as! UIFont
						var replaceFont = pfont(font.pointSize)
						if font.pointSize < 14 {
							replaceFont = pfont(14)
						}
						attrStr?.addAttributes([NSAttributedString.Key.font : replaceFont], range: range)
					}
					
					if key == .link {
						attrStr?.addAttributes([.foregroundColor : CommonColor.mainRed.color], range: range)
						attrStr?.addAttributes([.strokeColor : CommonColor.mainRed.color], range: range)
						print(range)
					}
				})
			}
			self.desTextView.attributedText = attrStr;
		}catch _ as NSError {
			let content = NSAttributedString.init(string: self.episode.intro+"\n", attributes: [NSAttributedString.Key.font : pfont(14), NSAttributedString.Key.foregroundColor: CommonColor.content.color])
			self.desTextView.attributedText = content
		}
		self.desTextView.snp.remakeConstraints { (make) in
			make.leading.equalTo(self.containerView).offset(16);
			make.trailing.equalTo(self.containerView).offset(-16);
			make.top.equalTo(self.playBtn.snp.bottom).offset(24)
			make.height.equalTo(self.desTextView.contentSize.height)
		}
		self.view.layoutIfNeeded()
	}
	
}

