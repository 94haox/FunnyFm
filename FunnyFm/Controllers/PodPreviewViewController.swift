//
//  PodPreviewViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/2/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
import OfficeUIFabric

class PodPreviewViewController: BaseViewController {
	
	var podImageView: UIImageView!
	var podNameLB: UILabel!
	var desLB: UILabel!
	var sourceLB: UILabel!
	var authorLB: UILabel!
	var subscribeBtn: UIButton!
	var loadingView: UIActivityIndicatorView!
	var pod: Pod!
	var itunsPod: iTunsPod!
	var addLoadView: NVActivityIndicatorView!
	var subTempView: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.dw_addSubViews()
		self.dw_addConstraints()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		FMToolBar.shared.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if FMPlayerManager.shared.currentModel.isSome {
			FMToolBar.shared.isHidden = false
		}
	}
	
	func configWithPod(pod :Pod){
		self.pod = pod;
		self.podNameLB.text = pod.name
		self.authorLB.text = pod.author
		self.desLB.text = pod.des
		self.podImageView.loadImage(url: pod.img)
		self.sourceLB.text = "来自：" + pod.sourceType;
	}
	
	func configWithPod(pod :iTunsPod){
		self.itunsPod = pod;
		self.podNameLB.text = pod.trackName
		self.authorLB.text = pod.podAuthor
		self.podImageView.loadImage(url:pod.artworkUrl600)
//		self.sourceLB.text = "来自：" + "iTunes";
	}
	
	@objc func addPodToLibary(){
		self.shinkBtn()
		SwiftNotice.showText("添加成功，正在获取所有节目单，请稍候查看")
		DatabaseManager.addItunsPod(pod: self.itunsPod);
		var params = [String: String]()
		params["track_name"] = self.itunsPod.trackName;
		params["rss_url"] = self.itunsPod.feedUrl;
		params["collection_id"] = self.itunsPod.collectionId;
		params["source_type"] = "iTunes";
		params["artwork_url"] = self.itunsPod.artworkUrl600
		NotificationCenter.default.post(name: NSNotification.Name.init(kParserNotification), object: nil)
		PodListViewModel.init().registerPod(params: params, success: { (msg) in
			self.dismiss(animated: true, completion: {
				if !PrivacyManager.isOpenPusn() {
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kSetupNotification), object: nil)
				}
			})
		}) { (msg) in
		}
	}
	
	func shinkBtn() {
		self.subscribeBtn.isHidden = true
		self.subTempView.cornerRadius = 5.0
		self.subTempView.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 10, height: 10))
			make.centerY.equalTo(self.subscribeBtn)
			make.right.equalTo(self.addLoadView)
		}
		
		UIView.animate(withDuration: 0.3, animations: {
			self.view.layoutIfNeeded()
		}) { (complete) in
			self.addLoadView.startAnimating()
			self.subTempView.isHidden = true
		};
	}
}


extension PodPreviewViewController: ViewModelDelegate {
	func viewModelDidGetDataSuccess() {
		SwiftNotice.showText("添加成功，正在抓取所有节目单，请稍候刷新")
		self.dismiss(animated: true, completion: nil)
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
	}
	
}


extension PodPreviewViewController {
	
	func dw_addConstraints(){
		self.podImageView.snp.makeConstraints { (make) in
			make.top.equalTo(self.view).offset(44);
			make.left.equalTo(self.view).offset(15);
			make.size.equalTo(CGSize.init(width: 150, height: 150));
		}
		
		self.podNameLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.podImageView).offset(5);
			make.left.equalTo(self.podImageView.snp.right).offset(10);
			make.right.equalTo(self.view).offset(-6);
		}
		
		self.authorLB.snp.makeConstraints { (make) in
			make.width.left.equalTo(self.podNameLB);
			make.top.equalTo(self.podNameLB.snp.bottom).offset(12)
		}
		
		self.sourceLB.snp.makeConstraints { (make) in
			make.width.left.equalTo(self.podNameLB);
			make.top.equalTo(self.authorLB.snp.bottom).offset(12)
		}
		
		self.desLB.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.view);
			make.width.equalTo(self.view).offset(-30);
			make.top.equalTo(self.podImageView.snp.bottom).offset(12)
		}
		
		self.subscribeBtn.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.view);
			make.width.equalTo(self.view).offset(-30);
			make.height.equalTo(50);
			make.top.equalTo(self.desLB.snp.bottom).offset(20)
		}
		
		self.subTempView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.subscribeBtn)
		}
		
		self.loadingView.snp.makeConstraints { (make) in
			make.center.equalTo(self.podImageView)
		}
		
		self.addLoadView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 50, height: 50))
			make.centerY.equalTo(self.subscribeBtn);
			make.centerX.equalTo(self.view)
		}
	}
	
	func dw_addSubViews() {
		
		self.loadingView = UIActivityIndicatorView.init(style: .gray)
		self.loadingView.startAnimating()
		self.view.addSubview(self.loadingView)
		
		self.podImageView = UIImageView.init()
		self.podImageView.cornerRadius = 15
		self.view.addSubview(self.podImageView)
		
		self.podNameLB = UILabel.init();
		self.podNameLB.font = h_bfont(22);
		self.podNameLB.textColor = .black
		self.podNameLB.numberOfLines = 2;
		self.view.addSubview(self.podNameLB)
		
		self.desLB = UILabel.init();
		self.desLB.font = hfont(14);
		self.desLB.numberOfLines = 3;
		self.desLB.textColor = CommonColor.content.color
		self.view.addSubview(self.desLB)
		
		self.sourceLB = UILabel.init();
		self.sourceLB.font = hfont(14);
		self.sourceLB.textColor = CommonColor.content.color
		self.view.addSubview(self.sourceLB)
		
		self.authorLB = UILabel.init()
		self.authorLB.font = hfont(14)
		self.authorLB.textColor = CommonColor.content.color
		self.view.addSubview(self.authorLB)
		
		
		self.subTempView = UIView.init()
		self.subTempView.cornerRadius = 15;
		self.subTempView.layer.masksToBounds = true;
		self.subTempView.backgroundColor = CommonColor.mainRed.color
		self.view.addSubview(self.subTempView)
		
		self.subscribeBtn = UIButton.init(type: .custom)
		self.subscribeBtn.setTitle("添加至订阅库", for: .normal)
		self.subscribeBtn.setTitleColor(.white, for: .normal)
		self.subscribeBtn.titleLabel?.font = h_bfont(18);
		self.subscribeBtn.cornerRadius = 15;
		self.subscribeBtn.layer.masksToBounds = true;
		self.subscribeBtn.backgroundColor = CommonColor.mainRed.color
		self.subscribeBtn.addTarget(self, action: #selector(addPodToLibary), for: .touchUpInside)
		self.view.addSubview(self.subscribeBtn)
		
		self.addLoadView = NVActivityIndicatorView.init(frame: CGRect.zero, type: NVActivityIndicatorType.pacman, color: CommonColor.mainRed.color, padding: 2);
		self.view.addSubview(self.addLoadView);
	}
	
	
}
