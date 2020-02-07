//
//  PodPreviewViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/2/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SnapKit
import OfficeUIFabric

class PodPreviewViewController: BaseViewController {
	
	var infoView: PodcastInfoView!
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
	var pod: Pod!
	var itunsPod: iTunsPod!
	var viewModel: PodDetailViewModel!
	var tableview : UITableView! = UITableView.init(frame: CGRect.zero, style: .plain)
	var backBtn: UIButton = UIButton.init(type: .custom)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.viewModel = PodDetailViewModel.init(podcast: self.itunsPod)
		self.dw_addSubViews()
		self.dw_addConstraints()
		self.configWithPod(pod: itunsPod)
		self.infoView.subscribeClosure = { [weak self] in
			self?.addPodToLibary()
		}
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
		MSHUD.shared.show(in: self.view)
		DatabaseManager.addItunsPod(pod: self.itunsPod);
		var params = [String: String]()
		params["track_name"] = self.itunsPod.trackName;
		params["rss_url"] = self.itunsPod.feedUrl;
		params["collection_id"] = self.itunsPod.collectionId;
		params["source_type"] = "iTunes";
		params["artwork_url"] = self.itunsPod.artworkUrl600
		params["author"] = self.viewModel.pod?.podAuthor
		PodListViewModel.init().registerPod(params: params, success: { [weak self] (msg) in
			MSHUD.shared.hide()
			SwiftNotice.showText("添加成功，正在获取所有节目单，请稍候查看".localized)
			NotificationCenter.default.post(Notification.init(name: Notification.willAddPrevPodcast))
			FeedManager.shared.parserForSingle(feedUrl: self!.itunsPod.feedUrl, collectionId: self!.itunsPod.collectionId,complete: nil)
			self!.dismiss(animated: true, completion: nil)
		}) { (msg) in
			MSHUD.shared.hide()
		}
	}
	
	@objc func backAction(){
		self.dismiss(animated: true, completion: nil)
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
		if self.viewModel.episodeList.count > 1 {
			self.loadingView.removeFromSuperview()
		}
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
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		let titleLB = UILabel.init(text: "Last 15 Episodes")
		titleLB.font = numFont(14)
		titleLB.textColor = CommonColor.content.color
		view.addSubview(titleLB)
		view.backgroundColor = .white
		titleLB.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().offset(16)
		}
		return view;
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
}


extension PodPreviewViewController {
	
	func dw_addConstraints(){
		
		
		
		self.loadingView.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
		
		self.tableview.snp.makeConstraints { (make) in
			make.top.left.width.bottom.equalTo(self.view)
		}
	}
	
	func dw_addSubViews() {
        self.infoView = PodcastInfoView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 260))
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		let cellnib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
		self.tableview.sectionHeaderHeight = 36
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
		self.tableview.separatorStyle = .none
		self.tableview.rowHeight = 100
		self.tableview.dataSource = self
		self.tableview.delegate = self
		self.tableview.tableHeaderView = self.infoView;
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
		self.view.addSubview(self.tableview)
		
		self.loadingView.startAnimating()
		self.view.addSubview(self.loadingView)
		
		if !UIDevice.current.systemVersion.hasPrefix("13.") {
			self.backBtn.setImageForAllStates(UIImage.init(named: "back-white")!)
			self.backBtn.cornerRadius = 5
			self.backBtn.backgroundColor = CommonColor.mainRed.color
			self.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
			self.view.addSubview(self.backBtn)
			
			self.backBtn.snp.makeConstraints { (make) in
				make.size.equalTo(CGSize.init(width: 25, height: 25))
				make.left.equalTo(self.view).offset(18)
				make.top.equalTo(self.view.snp_topMargin)
			}
		}
	}
	
	
}
