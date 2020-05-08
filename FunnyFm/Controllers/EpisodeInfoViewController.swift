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
	
	var tipLB: UILabel = UILabel.init(text: "播放列表".localized)
	
    var loadingView : UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
	
	var authorLB: UILabel!
	
	var playBtn: UIButton = UIButton.init(type: .custom)
	
	var noteListBtn: UIButton = UIButton.init(type: .custom)
	
	var insertBtn: UIButton = UIButton.init(type: .custom)
	
	var addBtn: UIButton = UIButton.init(type: .custom)
	
	var downloadBtn: UIButton = UIButton.init(type: .custom)
	
	var infoTextView: MPILabel!
	
	var episode: Episode!
	
	var progressBar: HistoryProgressBar!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dw_addSubviews()
		self.dw_addConstrants()
		self.config(content: episode)
		DownloadManager.shared.delegate = self
		DispatchQueue.global().async {
			PlayListManager.shared.updatePlayQueue()
			if PlayListManager.shared.isAlreadyIn(episode: self.episode) {
				DispatchQueue.main.async {
					self.addBtn.isSelected = true
				}
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		FMToolBar.shared.shrink()
	}
	
	
}

// MARK: Actions
extension EpisodeInfoViewController {
	
	@objc func playAction(){
		self.playBtn.bounce()
		if self.playBtn.isSelected {
			FMToolBar.shared.toobarPause()
		}else{
			FMToolBar.shared.configToolBarAtHome(self.episode)
		}
		self.playBtn.isSelected = !self.playBtn.isSelected;
	}
	
	@objc func showNoteList(){
		let listVC = NoteListViewController.init()
		listVC.episode = self.episode
		self.dw_presentAsStork(controller: listVC, heigth: kScreenHeight*0.4, delegate: self)
	}
	
	@objc func downloadAction(){
		ImpactManager.impact()
		if !self.downloadBtn.isSelected {
			let _ = DownloadManager.shared.beginDownload(self.episode)
			self.progressBar.isHidden = false
		}else{
			if let _ = DatabaseManager.qureyDownload(title: self.episode.title) {
				DatabaseManager.deleteDownload(title: self.episode.title);
				self.downloadBtn.setImage(UIImage.init(named: "download_icon"), for: .normal)
				self.downloadBtn.isSelected = false
				return
			}else{
				DownloadManager.shared.stopDownload(episode: self.episode)
			}
		}
		self.downloadBtn.isSelected = !self.downloadBtn.isSelected;
	}
	
	@objc func addAction(){
		
		if  FMPlayerManager.shared.currentModel.isSome  {
			if FMPlayerManager.shared.currentModel!.trackUrl == self.episode.trackUrl {
				self.addBtn.shake()
				SwiftNotice.noticeOnStatusBar("正在播放".localized, autoClear: true, autoClearTime: 1)
				return
			}
		}
				
		if self.addBtn.isSelected {
			PlayListManager.shared.queueOut(episode: self.episode)
			self.addBtn.bounce()
		}else{
			self.addBtn.bounce()
			PlayListManager.shared.queueIn(episode: self.episode)
		}
		
		self.addBtn.isSelected = !self.addBtn.isSelected
		
	}
	
	@objc func insertAction(){
		if  FMPlayerManager.shared.currentModel.isSome  {
			if FMPlayerManager.shared.currentModel!.trackUrl == self.episode.trackUrl {
				self.insertBtn.shake()
				SwiftNotice.noticeOnStatusBar("正在播放".localized, autoClear: true, autoClearTime: 1)
				return
			}
		}

		self.insertBtn.bounce()
		PlayListManager.shared.queueInsertAffter(episode: self.episode)
	}
	
}

extension EpisodeInfoViewController: DownloadManagerDelegate {
	
	func downloadProgress(progress: Double, sourceUrl: String) {
		if self.episode.trackUrl != sourceUrl {
			return
		}
		self.downloadBtn.isSelected = true
		self.progressBar.isHidden = false
		self.progressBar.update(with: progress)
	}
	
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String) {
		if self.episode.trackUrl != sourceUrl {
			return
		}
		self.progressBar.isHidden = true
        self.downloadBtn.setImage(UIImage.init(named: "trash")?.tintImage, for: .normal)
		self.downloadBtn.isSelected = false
	}
	
	func didDownloadFailure(sourceUrl: String) {
		if self.episode.trackUrl != sourceUrl {
			return
		}
		self.progressBar.isHidden = true
		self.downloadBtn.isSelected = false
	}
}

extension EpisodeInfoViewController {
	
	func config(content: Episode) {
		
		
		if FMPlayerManager.shared.currentModel.isSome {
			if FMPlayerManager.shared.currentModel!.title == self.episode.title && FMPlayerManager.shared.isPlay {
				self.playBtn.isSelected = true
			}
		}
		
		if DownloadManager.shared.downloadKeys.contains(self.episode.trackUrl) {
			self.downloadBtn.isSelected = true
		}
		
		if let _ = DatabaseManager.qureyDownload(title: self.episode.title) {
            self.downloadBtn.setImage(UIImage.init(named: "trash")!.tintImage, for: .selected)
			self.downloadBtn.isSelected = true
		}
		
		self.episodeImageView.loadImage(url: episode.coverUrl)
		self.titleLB.text = episode.title
		self.authorLB.text = episode.author
		self.episode.intro = episode.title + "\n\n" + self.episode.intro
		guard self.episode.intro.contains("<") else {
			self.episode.intro = self.episode.intro.replacingOccurrences(of: "。", with: "。\n")
            self.episode.intro = self.episode.intro.replacingOccurrences(of: "[", with: "\n[")
			let content = NSAttributedString.init(string: self.episode.intro, attributes: [NSAttributedString.Key.font : pfont(14), NSAttributedString.Key.foregroundColor: CommonColor.content.color])
            self.infoTextView.attributedText = content
            self.infoTextView.truncationAttributedToken = MPITextDefaultTruncationAttributedToken()
			self.loadingView.removeSubviews()
			self.view.layoutIfNeeded()
			return
		}
		
		DispatchQueue.global().async {
			do{
				self.episode.intro = self.episode.title + "<br><br>" + self.episode.intro
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
						if key == .foregroundColor {
							attrStr?.addAttributes([NSAttributedString.Key.foregroundColor: CommonColor.content.color], range: range)
						}
						
						if key == .link {
							attrStr?.addAttributes([.foregroundColor : R.color.mainRed()!], range: range)
							attrStr?.addAttributes([.strokeColor : R.color.mainRed()!], range: range)
						}
					})
				}
				DispatchQueue.main.async {
                    self.infoTextView.attributedText = attrStr
					self.infoTextView.truncationAttributedToken = MPITextDefaultTruncationAttributedToken();
					self.loadingView.removeSubviews()
				}
			}catch _ as NSError {
				let content = NSAttributedString.init(string: (self.episode.title + "\n\n" + self.episode.intro), attributes: [NSAttributedString.Key.font : pfont(14), NSAttributedString.Key.foregroundColor: CommonColor.content.color])
				DispatchQueue.main.async {
                    self.infoTextView.attributedText = content;
                    self.infoTextView.truncationAttributedToken = MPITextDefaultTruncationAttributedToken()
					self.loadingView.removeSubviews()
				}
			}
			
			DispatchQueue.main.async {
				self.view.layoutIfNeeded()
			}
		}
	}
	
}

extension EpisodeInfoViewController: MPILabelDelegate {
    
    func label(_ label: MPILabel, didInteractWith link: MPITextLink, forAttributedText attributedText: NSAttributedString, in characterRange: NSRange, interaction: MPITextItemInteraction) {
        
    }
    
}


extension EpisodeInfoViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		SPStorkController.scrollViewDidScroll(scrollView)
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
		self.containerView.addSubview(self.tipLB)
		self.containerView.addSubview(self.downloadBtn)
		self.containerView.addSubview(self.noteListBtn)
		self.containerView.addSubview(self.insertBtn)
		self.containerView.addSubview(self.addBtn)
		self.containerView.addSubview(self.infoTextView)
		self.containerView.addSubview(self.progressBar);
		self.containerView.addSubview(self.loadingView);
		
		
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
			make.right.equalTo(self.noteListBtn.snp_left).offset(-24)
			make.height.equalTo(40)
		}
		
		self.noteListBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.playBtn)
			make.right.equalTo(self.downloadBtn.snp_left).offset(-16)
			make.height.equalTo(self.playBtn)
			make.width.equalTo(50)
		}
		
		self.downloadBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.playBtn)
			make.right.equalToSuperview().offset(-16)
			make.height.equalTo(self.playBtn)
			make.width.equalTo(50)
		}
		
		self.tipLB.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(self.playBtn.snp.bottom).offset(18)
		}
		
		self.insertBtn.snp.makeConstraints { (make) in
			make.left.equalTo(self.playBtn)
			make.width.equalToSuperview().multipliedBy(0.5).offset(-26)
			make.height.equalTo(self.playBtn)
			make.top.equalTo(self.tipLB.snp.bottom).offset(8)
		}
		
		self.addBtn.snp.makeConstraints { (make) in
			make.height.equalTo(self.playBtn)
			make.width.equalToSuperview().multipliedBy(0.5).offset(-26)
			make.right.equalTo(self.downloadBtn)
			make.centerY.equalTo(self.insertBtn)
		}
		
		self.progressBar.snp.makeConstraints { (make) in
			make.width.equalTo(self.downloadBtn)
			make.bottom.equalTo(self.downloadBtn.snp.top).offset(-4)
			make.centerX.equalTo(self.downloadBtn);
			make.height.equalTo(4);
		}
		
		self.infoTextView.snp.makeConstraints { (make) in
			make.top.equalTo(self.addBtn.snp.bottom).offset(24)
			make.leading.equalTo(self.containerView).offset(16);
			make.trailing.equalTo(self.containerView).offset(-16);
		}
		
		self.containerView.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.infoTextView).offset(50)
		}
		
		self.loadingView.snp.makeConstraints { (make) in
			make.top.equalTo(self.addBtn.snp.bottom).offset(50)
			make.centerX.equalToSuperview()
			
		}
		self.view.layoutIfNeeded()
		self.addBtn.centerTextAndImage(spacing: 30)
		self.insertBtn.centerTextAndImage(spacing: 30)
	}
	
	func dw_addSubviews(){
		
		self.infoTextView = MPILabel.init()
        self.infoTextView.numberOfLines = 0;
        self.infoTextView.delegate = self;
        self.infoTextView.isUserInteractionEnabled = true
		
		
		self.scrollView.backgroundColor = CommonColor.white.color
		self.scrollView.delegate = self
		self.episodeImageView.cornerRadius = 5;
		
		self.titleLB = UILabel.init(text: self.episode.title)
		self.titleLB.textColor = CommonColor.title.color
		self.titleLB.font = p_bfont(14)
		self.titleLB.numberOfLines = 2;
		
		self.authorLB = UILabel.init(text: self.episode.author)
		self.authorLB.textColor = CommonColor.content.color
		self.authorLB.font = p_bfont(10)
		
		self.playBtn.backgroundColor = R.color.mainRed()!
		self.playBtn.cornerRadius = 8
		self.playBtn.setTitle("播放".localized, for: .normal)
		self.playBtn.setTitle("暂停".localized, for: .selected)
		self.playBtn.titleLabel?.font = pfont(fontsize4)
		self.playBtn.addTarget(self, action: #selector(playAction), for: .touchUpInside)
		
		self.tipLB.textColor = R.color.mainRed()!
		self.tipLB.font = p_bfont(10)
		
		self.insertBtn.setTitleForAllStates("插播".localized)
		self.insertBtn.setTitleColorForAllStates(R.color.mainRed()!)
        self.insertBtn.setImageForAllStates(UIImage.init(named: "playlist_insert")!.tintImage)
        self.insertBtn.tintColor = R.color.mainRed()
		self.insertBtn.titleLabel?.font = pfont(fontsize4)
		self.insertBtn.addTarget(self, action: #selector(insertAction), for: .touchUpInside)
		self.insertBtn.backgroundColor = CommonColor.whiteBackgroud.color
		self.insertBtn.cornerRadius = 8
		self.insertBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
		

		self.addBtn.setTitle("从待播中移出".localized, for: .selected)
		self.addBtn.setTitle("待播".localized, for: .normal)
		self.addBtn.setTitleColorForAllStates(R.color.mainRed()!)
        self.addBtn.setImageForAllStates(UIImage.init(named: "playlist_nor")!.tintImage)
        self.addBtn.tintColor = R.color.mainRed()
		self.addBtn.titleLabel?.font = pfont(fontsize4)
		self.addBtn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
		self.addBtn.backgroundColor = CommonColor.whiteBackgroud.color
		self.addBtn.cornerRadius = 8
		self.addBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
		
		
        self.downloadBtn.backgroundColor = CommonColor.whiteBackgroud.color
		self.downloadBtn.cornerRadius = 8
        self.downloadBtn.setImage(UIImage.init(named: "download_icon")!.tintImage, for: .normal)
        self.downloadBtn.setImage(UIImage.init(named: "cancel")!.tintImage, for: .selected)
        self.downloadBtn.tintColor = R.color.mainRed()
		self.downloadBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
		self.downloadBtn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
		
		self.noteListBtn.backgroundColor = CommonColor.whiteBackgroud.color
		self.noteListBtn.cornerRadius = 8
        self.noteListBtn.setImageForAllStates(UIImage.init(named: "notelist_little")!.tintImage)
        self.noteListBtn.tintColor = R.color.mainRed()
		self.noteListBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
		self.noteListBtn.addTarget(self, action: #selector(showNoteList), for: .touchUpInside)
		
		self.progressBar = HistoryProgressBar.init(frame: CGRect.zero)
		self.progressBar.isHidden = true
		
		self.loadingView.startAnimating()
	}
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle == .dark {
            self.downloadBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
            self.noteListBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
            self.addBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
            self.insertBtn.addShadow(ofColor: CommonColor.background.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 1)
        }else{
            self.downloadBtn.cleanShadow()
            self.insertBtn.cleanShadow()
            self.noteListBtn.cleanShadow()
            self.addBtn.cleanShadow()
        }
    }
	
}

