//
//  SpeechViewController.swift
//  ComponentList
//
//  Created by Duke on 2019/11/20.
//  Copyright © 2019 duke. All rights reserved.
//

import UIKit
import Speech

class SpeechViewController: UIViewController {

	@IBOutlet weak var playBtn: UIButton!
	@IBOutlet weak var loadingView: UIActivityIndicatorView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var rangeLB: UILabel!
	@IBOutlet weak var localBtn: UIButton!
	@IBOutlet weak var sttBtn: UIButton!
	@IBOutlet weak var convertTextView: UITextView!
	var episode: Episode!
	var supportLocalListView: SupportLocalListView!
	var isRecing = false
	var startTime: Int = 0
	var localText: String = "en_US"
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.startTime = FMPlayerManager.shared.currentTime
		self.setUpUI()
    }

	@IBAction func changeLocalAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		self.supportLocalListView.snp.remakeConstraints { (make) in
			make.width.centerX.equalToSuperview()
			if sender.isSelected {
				make.top.equalTo(self.topView)
			}else{
				make.top.equalTo(self.view.snp.bottom)
			}
			make.bottom.equalTo(self.view.snp.bottom)
		}
		
		UIView.animate(withDuration: 0.2, delay: 0, options: .transitionFlipFromBottom, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	@IBAction func sttAction(_ sender: Any) {
		self.isRecing = true
		self.loadingView.isHidden = false;
		self.loadingView.startAnimating()
		if let episode = DatabaseManager.qureyDownload(title: self.episode.title) {
			let url =  FMPlayerManager.shared.completePath(episode)
			SpeechManager.recognizeFile(url: url, local: self.localText, startTime: startTime) { (text) in
				self.loadingView.isHidden = true
				self.convertTextView.text = text
				self.isRecing = false
			}
		}
		
	}

}

extension SpeechViewController {
	
	func setUpUI(){
		self.rangeLB.text = "\(FunnyFm.formatIntervalToMM(startTime)) - \(FunnyFm.formatIntervalToMM(startTime+60))"
		
		self.topView.layer.cornerRadius = 5
		self.topView.layer.masksToBounds = true
		self.loadingView.isHidden = true;
		self.sttBtn.layer.cornerRadius = 5
		
		self.supportLocalListView = SupportLocalListView.init(frame: CGRect.zero)
		self.supportLocalListView.layer.cornerRadius = 5
		self.supportLocalListView.clipsToBounds = true
		self.view.addSubview(self.supportLocalListView);
		
		self.supportLocalListView.snp.remakeConstraints { (make) in
			make.width.centerX.equalToSuperview()
			if self.localBtn.isSelected {
				make.top.equalTo(self.topView)
			}else{
				make.top.equalTo(self.view.snp.bottom)
			}
			make.bottom.equalTo(self.view.snp.bottom)
		}
		self.supportLocalListView.changeLocalClosure = { (title, value) in
			self.localBtn.setTitle(title, for: .normal)
			self.changeLocalAction(self.localBtn)
			self.localText = value
		}
	
	}
	
}
