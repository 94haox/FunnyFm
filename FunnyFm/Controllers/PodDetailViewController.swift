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
	
	var infoView: PodcastInfoView = PodcastInfoView.init(frame: CGRect.zero)
	
	var pod: iTunsPod!
	
	var subBtn: UIButton!
	
	var shareBtn: UIButton!
	
	var tableview : UITableView!
	
	var refreshControl: UIRefreshControl!
	
	var vm: PodDetailViewModel!
	
	init(pod: iTunsPod) {
		super.init(nibName: nil, bundle: nil)
		self.pod = pod
		self.vm = PodDetailViewModel.init(podcast: pod)
		self.vm.delegate = self
	}
	
	deinit {
		if self.subBtn.isSelected {
			FeedManager.shared.deleteAllEpisode(collectionId: self.pod.collectionId, podId: self.pod.podId)
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
		self.subBtn.isSelected = !self.subBtn.isSelected;
		self.subBtn.backgroundColor = self.subBtn.isSelected ? .white : CommonColor.mainRed.color
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
	
	func viewModelDidGetDataFailture(msg: String?) {}
		
	func podDetailParserSuccess() {
		DispatchQueue.main.async {
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
}


extension PodDetailViewController {
	
	func addHeader(){
		refreshControl = UIRefreshControl.init()
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		self.tableview.refreshControl = refreshControl;
	}
	
	func dw_addConstraints(){
		self.view.addSubview(self.tableview)
		self.view.addSubview(self.infoView)
		self.view.addSubview(self.subBtn)
		self.view.addSubview(self.shareBtn)
		
		self.infoView.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.top.equalTo(self.view.snp.topMargin)
			make.height.equalTo(260)
		}
		
		
		self.shareBtn.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-16.adapt())
			make.top.equalTo(self.infoView).offset(12)
			make.size.equalTo(CGSize.init(width: 25, height: 25))
		}
		
		
		self.subBtn.snp.makeConstraints { (make) in
			make.width.equalTo(70)
			make.height.equalTo(30)
			make.centerX.equalToSuperview()
			make.top.equalTo(self.infoView.snp.bottom).offset(6)
		}
		
		
		self.tableview.snp.makeConstraints { (make) in
			make.left.width.bottom.equalToSuperview();
			make.top.equalTo(self.subBtn.snp.bottom).offset(6)
		}
		
	}
	
	func addSubviews(){
		
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
		
		self.shareBtn = UIButton.init(type: .custom)
		self.shareBtn.setImageForAllStates(UIImage.init(named: "share-red")!)
		self.shareBtn.addTarget(self, action: #selector(sharePodcast), for: .touchUpInside)
//		self.shareBtn.backgroundColor = .white
		self.shareBtn.cornerRadius = 5
		self.shareBtn.addShadow(ofColor: CommonColor.content.color, radius: 3, offset: CGSize.init(width: 3, height: 3), opacity: 1)
		
		
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		let cellnib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
		self.tableview.sectionHeaderHeight = 36
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
		self.tableview.separatorStyle = .none
		self.tableview.rowHeight = 100
		self.tableview.delegate = self
		self.tableview.dataSource = self
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
		
	}
	
}
