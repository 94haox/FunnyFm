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
	
	var infoView: PodcastInfoView = PodcastInfoView.init(frame: CGRect.zero)
	var subscribeBtn: UIButton!
	var loadingView: UIActivityIndicatorView!
	var pod: Pod!
	var itunsPod: iTunsPod!
	var addLoadView: NVActivityIndicatorView!
	var subTempView: UIView!
	var viewModel: PodDetailViewModel!
	var tableview : UITableView! = UITableView.init(frame: CGRect.zero, style: .plain)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.dw_addSubViews()
		self.dw_addConstraints()
		self.configWithPod(pod: itunsPod)
		self.viewModel = PodDetailViewModel.init(podcast: self.itunsPod)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		FMToolBar.shared.isHidden = true
		DispatchQueue.global(qos: .background).async {
			self.viewModel.delegate = self;
			self.viewModel.getPodcastPrev(pod: self.itunsPod)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if FMPlayerManager.shared.currentModel.isSome {
			FMToolBar.shared.isHidden = false
		}
	}
	
	func config(pod :Pod){
		self.pod = pod;
//		self.podNameLB.text = pod.title
//		self.authorLB.text = pod.author
//		self.desLB.text = pod.description
//		self.podImageView.loadImage(url: pod.image)
	}
	
	func configWithPod(pod :iTunsPod){
		self.infoView.config(pod: pod)
	}
	
	@objc func addPodToLibary(){
		self.shinkBtn()
		SwiftNotice.showText("添加成功，正在获取所有节目单，请稍候查看".localized)
		DatabaseManager.addItunsPod(pod: self.itunsPod);
		var params = [String: String]()
		params["track_name"] = self.itunsPod.trackName;
		params["rss_url"] = self.itunsPod.feedUrl;
		params["collection_id"] = self.itunsPod.collectionId;
		params["source_type"] = "iTunes";
		params["artwork_url"] = self.itunsPod.artworkUrl600
		params["author"] = self.viewModel.pod?.podAuthor
		PodListViewModel.init().registerPod(params: params, success: { [weak self] (msg) in
			FeedManager.shared.parserForSingle(feedUrl: self!.itunsPod.feedUrl, collectionId: self!.itunsPod.collectionId,complete: nil)
			self!.dismiss(animated: true, completion: nil)
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
		SwiftNotice.showText("添加成功，正在获取所有节目单，请稍候查看".localized)
		self.dismiss(animated: true, completion: nil)
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		
	}
	
}

extension PodPreviewViewController : PodDetailViewModelDelegate {
	
	func podDetailParserSuccess() {
		DispatchQueue.main.async {
			if self.viewModel.pod.isSome {
				self.configWithPod(pod: self.viewModel.pod!)
				self.tableview.reloadData()
				self.loadingView.removeFromSuperview()
			}
		}
	}
	
	func podDetailCancelSubscribeSuccess() {
		
	}
}

extension PodPreviewViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		SwiftNotice.showText("您尚未订阅哦😯")
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.episodeList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? HomeAlbumTableViewCell else { return }
		let episode = self.viewModel.episodeList[indexPath.row]
		cell.configNoDetailCell(episode)
	}
}


extension PodPreviewViewController {
	
	func dw_addConstraints(){
		
		self.infoView.snp.makeConstraints { (make) in
			make.left.width.top.equalToSuperview()
			make.height.equalTo(260.auto())
		}
		
		self.subscribeBtn.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.view);
			make.width.equalTo(self.view).offset(-30);
			make.height.equalTo(40);
			make.top.equalTo(self.infoView.snp.bottom).offset(6)
		}
		
		self.subTempView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.subscribeBtn)
		}
		
		self.loadingView.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
		
		self.addLoadView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 50, height: 50))
			make.centerY.equalTo(self.subscribeBtn);
			make.centerX.equalTo(self.view)
		}
		
		self.tableview.snp.makeConstraints { (make) in
			make.left.width.bottom.equalTo(self.view)
			make.top.equalTo(self.subscribeBtn.snp.bottom).offset(16);
		}
	}
	
	func dw_addSubViews() {
		
		self.view.addSubview(self.infoView)
		
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		let cellnib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
		self.tableview.sectionHeaderHeight = 36
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
		self.tableview.separatorStyle = .none
		self.tableview.rowHeight = 100
		self.tableview.dataSource = self
		self.tableview.delegate = self
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
		self.view.addSubview(self.tableview)
		
		self.loadingView = UIActivityIndicatorView.init(style: .gray)
		self.loadingView.startAnimating()
		self.view.addSubview(self.loadingView)
		
		
		self.subTempView = UIView.init()
		self.subTempView.cornerRadius = 15;
		self.subTempView.layer.masksToBounds = true;
		self.subTempView.backgroundColor = CommonColor.mainRed.color
		self.view.addSubview(self.subTempView)
		
		self.subscribeBtn = UIButton.init(type: .custom)
		self.subscribeBtn.setTitle("查看更多请订阅".localized, for: .normal)
		self.subscribeBtn.setTitleColor(.white, for: .normal)
		self.subscribeBtn.titleLabel?.font = h_bfont(16);
		self.subscribeBtn.cornerRadius = 15;
		self.subscribeBtn.layer.masksToBounds = true;
		self.subscribeBtn.backgroundColor = CommonColor.mainRed.color
		self.subscribeBtn.addTarget(self, action: #selector(addPodToLibary), for: .touchUpInside)
		self.view.addSubview(self.subscribeBtn)
		
		self.addLoadView = NVActivityIndicatorView.init(frame: CGRect.zero, type: NVActivityIndicatorType.pacman, color: CommonColor.mainRed.color, padding: 2);
		self.view.addSubview(self.addLoadView);
	}
	
	
}
