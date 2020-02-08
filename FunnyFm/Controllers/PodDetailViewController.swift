//
//  PodDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import EFIconFont
import AutoInch

class PodDetailViewController: BaseViewController {
	
	var infoView: PodcastInfoView!
	var pod: iTunsPod!
	
	var shareBtn: UIButton!
	
	var tableview : UITableView!
	
	var refreshControl: UIRefreshControl!
	
	var loadingView: UIActivityIndicatorView!
	
	var vm: PodDetailViewModel!
	
	init(pod: iTunsPod) {
		super.init(nibName: nil, bundle: nil)
		self.pod = pod
		self.vm = PodDetailViewModel.init(podcast: pod)
		self.vm.delegate = self
	}
	
	deinit {
		if self.infoView.subBtn.isSelected {
			FeedManager.shared.deleteAllEpisode(podcastUrl: self.pod.feedUrl, podId: self.pod.podId)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.addSubviews()
		self.addHeader()
		self.dw_addConstraints()
		FeedManager.shared.delegate = self
		self.config()
		self.infoView.subscribeClosure = { [weak self] in
			self?.subscribtionAction()
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.refreshData()
	}

	func config(){
		self.title = "detail"
		self.infoView.config(pod: self.pod)
	}
	
	@objc func subscribtionAction() {
		ImpactManager.impact()
		self.infoView.subBtn.isSelected = !self.infoView.subBtn.isSelected;
		self.infoView.subBtn.backgroundColor = self.infoView.subBtn.isSelected ? .white : CommonColor.mainRed.color
	}
	
	func toDetail(episode: Episode) {
		let detailVC = EpisodeInfoViewController.init()
		detailVC.episode = episode
		self.navigationController?.dw_presentAsStork(controller: detailVC, heigth: kScreenHeight * 0.6, delegate: self)
	}
	
	@objc func refreshData (){
		self.vm.parserNewChapter(pod: self.pod!)
	}
	
	@objc func sharePodcast(){
		if self.pod.podId.length() < 1 {
			return
		}
		let url = podcastShareUrl.appending(self.pod.podId)
		let textToShare = self.pod.trackName
		let imageToShare = self.infoView.podImageView.image!
		let urlToShare = NSURL.init(string: url)
        var items = ["funnyfm",textToShare,imageToShare] as [Any]
        if urlToShare != nil {
            items.append(urlToShare!)
        }
        let activityVC = VisualActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
	}
	
}



extension PodDetailViewController: PodDetailViewModelDelegate{
	
	func viewModelDidGetDataSuccess() {
		
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		
	}
		
	func podDetailParserSuccess() {
		DispatchQueue.main.async {
			self.tableview.refreshControl?.endRefreshing()
			self.tableview.reloadData()
			self.infoView.config(pod: self.vm.pod!)
		}
	}
	
	func podDetailCancelSubscribeSuccess() {
	
	}
}

extension PodDetailViewController: FeedManagerDelegate {
	
	func feedManagerDidGetEpisodelistSuccess() {
		self.tableview.refreshControl?.endRefreshing()
		self.tableview.reloadData()
	}
	
	
	func feedManagerDidParserPodcasrSuccess() {
		
	}
	
}


extension PodDetailViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let episode = self.vm.episodeList[indexPath.row]
		FMToolBar.shared.isHidden = false
		FMToolBar.shared.configToolBar(episode)
	}
	
}

extension PodDetailViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.vm.episodeList.count > 0 {
			self.loadingView.removeFromSuperview()
		}
		return self.vm.episodeList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? HomeAlbumTableViewCell else { return }
		let episode = self.vm.episodeList[indexPath.row]
		cell.configCell(episode)
		cell.tranferNoParameterClosure { [weak self] in
			self?.toDetail(episode: episode)
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		let titleLB = UILabel.init(text: "All Episodes")
		titleLB.font = numFont(14)
		titleLB.textColor = CommonColor.content.color
		view.addSubview(titleLB)
        view.backgroundColor = CommonColor.white.color
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


extension PodDetailViewController {
	
	func addHeader(){
		refreshControl = UIRefreshControl.init()
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		self.tableview.refreshControl = refreshControl;
	}
	
	func dw_addConstraints(){
		self.view.addSubview(self.tableview)
		self.view.addSubview(self.loadingView)
		
		self.tableview.snp.makeConstraints { (make) in
			make.left.width.bottom.equalToSuperview();
			make.top.equalTo(self.view.snp_topMargin)
		}
		
		self.loadingView.snp.makeConstraints { (make) in
			make.center.equalTo(self.tableview)
			make.size.equalTo(CGSize.init(width: 50, height: 50))
		}
		
	}
	
	func addSubviews(){
        
        self.view.backgroundColor = CommonColor.white.color
        self.infoView = PodcastInfoView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 260))
		
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		self.tableview.tableHeaderView = self.infoView
		let cellnib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
		self.tableview.sectionHeaderHeight = 36
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
		self.tableview.separatorStyle = .none
		self.tableview.rowHeight = 100
		self.tableview.delegate = self
		self.tableview.dataSource = self
        self.tableview.backgroundColor = CommonColor.white.color
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: toolbarH*2, right: 0)
		
        self.loadingView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
		self.loadingView.startAnimating()
		
	}
	
}
