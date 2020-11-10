//
//  PodDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import AutoInch
import SwipeCellKit

class PodDetailViewController: BaseViewController {
	
    var infoView: PodcastInfoView = PodcastInfoView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 260.auto()))
    
    var sortedBtn: UIButton = UIButton.init(type: .custom)
    
    var wallBtn: UIButton = UIButton.init(type: .custom)
	
	var shareBtn: UIButton!
	
	var tableview : UITableView!
	
	var refreshControl: UIRefreshControl!
	
	var loadingView: UIActivityIndicatorView!
	
	var vm: PodDetailViewModel!
	
	init(pod: iTunsPod) {
		super.init(nibName: nil, bundle: nil)
		self.vm = PodDetailViewModel.init(podcast: pod)
		self.vm.delegate = self
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
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareAction))
    }
    
    @objc func shareAction() {
        let qrcodeVC = QRCodeViewController()
        qrcodeVC.podcast = self.vm.pod
        navigationController?.pushViewController(qrcodeVC, animated: true)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.refreshData()
	}

	func config(){
		self.title = "Podcast"
        self.infoView.config(pod: self.vm.pod!)
	}
	
	@objc func subscribtionAction() {
		ImpactManager.impact()
		self.infoView.subBtn.isSelected = !self.infoView.subBtn.isSelected;
		self.infoView.subBtn.backgroundColor = self.infoView.subBtn.isSelected ? .white : R.color.mainRed()!
        if self.infoView.subBtn.isSelected {
            showHud(style: .busy, text: "")
            FeedManager.shared.deleteAllEpisode(podcastUrl: self.vm.pod!.feedUrl, podId: self.vm.pod!.podId)
        }
	}
	
	func toDetail(episode: Episode) {
		let detailVC = EpisodeInfoViewController.init()
		detailVC.episode = episode
		self.navigationController?.dw_presentAsStork(controller: detailVC, heigth: kScreenHeight * 0.6, delegate: self)
	}
	
	@objc func refreshData (){
		self.vm.parserNewChapter(pod: self.vm.pod!)
	}
	
	@objc func sharePodcast(){
		if self.vm.pod!.podId.length() < 1 {
			return
		}
		let url = podcastShareUrl.appending(self.vm.pod!.podId)
		let textToShare = self.vm.pod!.trackName
		let imageToShare = self.infoView.podImageView.image!
		let urlToShare = NSURL.init(string: url)
        var items = ["funnyfm",textToShare,imageToShare] as [Any]
        if urlToShare != nil {
            items.append(urlToShare!)
        }
        let activityVC = VisualActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
	}
    
    @objc func sorted(btn: UIButton) {
        guard self.vm.episodeList.count > 0 else {
            return
        }
        ImpactManager.impact(.light)
        btn.isSelected = !btn.isSelected
        self.reload(needSorted: true)
    }
    
    @objc func showNeedVpnAlert() {
        showAutoHiddenHud(style: .error, text: "此播客中国国内网络暂不支持访问! 请切换网络后重试。".localized)
    }
        
    func reload(needSorted: Bool) {
        guard needSorted else {
            self.tableview.reloadData()
            return
        }
        self.vm.episodeList.sort { (obj1, obj2) -> Bool in
            if self.sortedBtn.isSelected {
               return obj1.pubDateSecond >= obj2.pubDateSecond
            }else{
                return obj1.pubDateSecond <= obj2.pubDateSecond
            }
        }
        self.tableview.reloadData()
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
			self.reload(needSorted: true)
			if let pod = self.vm.pod {
				self.infoView.config(pod: pod)
			}
		}
	}
	
	func podDetailCancelSubscribeSuccess() {
	
	}
}

extension PodDetailViewController: FeedManagerDelegate {
	
    func feedManagerDidGetEpisodelistSuccess(count: Int) {
		self.reload(needSorted: true)
	}
	
	
	func feedManagerDidParserPodcasrSuccess() {
		
	}
	
    func feedManagerDidDisSubscribeSuccess() {
        Hud.shared.hide()
        self.navigationController?.popViewController()
    }
}


extension PodDetailViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let episode = self.vm.episodeList[indexPath.row]
		FMToolBar.shared.configToolBar(episode)
		self.navigationController?.popViewController()
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
		let swipeCell = cell as SwipeTableViewCell
		swipeCell.delegate = self;
		let episode = self.vm.episodeList[indexPath.row]
        cell.configCell(episode)
		cell.tranferNoParameterClosure { [weak self] in
			self?.toDetail(episode: episode)
		}
        cell.addBlock = {
            PlayListManager.shared.queueIn(episode: episode)
            tableView.reloadData()
        }
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
        view.backgroundColor = CommonColor.white.color
		let titleLB = UILabel.init(text: "All Episodes")
		titleLB.font = numFont(14)
		titleLB.textColor = CommonColor.content.color
		view.addSubview(titleLB)
        view.addSubview(self.sortedBtn)
        view.addSubview(self.wallBtn)
		titleLB.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16.auto())
		}
        self.sortedBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16.auto())
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        
        self.wallBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.sortedBtn.snp.left).offset(-16.auto())
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        self.wallBtn.isHidden = !self.vm.pod!.isNeedVpn
		return view;
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
}

extension PodDetailViewController: SwipeTableViewCellDelegate {
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		let episode = self.vm.episodeList[indexPath.row]
		
		guard orientation == .right else {
			self.navigationController?.popViewController()
			return nil
		}
		
		if PlayListManager.shared.isAlreadyIn(episode: episode) {
			let deleteAction = SwipeAction(style: .default, title: "remove from list") { action, indexPath in
				PlayListManager.shared.queueOut(episode: episode)
				self.tableview .reloadData()
			}
			deleteAction.backgroundColor = R.color.mainRed()
			deleteAction.font = p_bfont(12)
			deleteAction.image = UIImage(systemName: "minus.circle")
			return [deleteAction]
		}
	
		let addAction = SwipeAction(style: .default, title: "add to list") { action, indexPath in
			PlayListManager.shared.queueIn(episode: episode)
			self.tableview .reloadData()
		}
		addAction.backgroundColor = R.color.mainRed()
		addAction.font = p_bfont(12)
		addAction.image = UIImage(systemName: "plus.circle")
		return [addAction]
	}
}


extension PodDetailViewController {
	
	func addHeader(){
		refreshControl = UIRefreshControl.init()
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		self.tableview.refreshControl = refreshControl;
	}
	
	func dw_addConstraints(){
        self.view.addSubviews([self.tableview, self.loadingView])
		
		self.tableview.snp.makeConstraints { (make) in
			make.left.width.bottom.equalToSuperview();
			make.top.equalTo(self.view.snp.topMargin)
		}
		
		self.loadingView.snp.makeConstraints { (make) in
			make.center.equalTo(self.tableview)
			make.size.equalTo(CGSize.init(width: 50, height: 50))
		}
		
	}
	
	func addSubviews(){
				
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		self.tableview.tableHeaderView = self.infoView
		let cellnib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
		self.tableview.sectionHeaderHeight = 36
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
        self.tableview.register(cellnib, forCellReuseIdentifier: "animationCell")
		self.tableview.separatorStyle = .none
		self.tableview.rowHeight = 85
		self.tableview.delegate = self
		self.tableview.dataSource = self
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
		
        self.loadingView = UIActivityIndicatorView.init(style: .medium)
		self.loadingView.startAnimating()
		
        self.sortedBtn.setImage(UIImage.init(named: "sort_down")?.tintImage, for: .normal)
        self.sortedBtn.setImage(UIImage.init(named: "sort_up")?.tintImage, for: .selected)
        self.sortedBtn.tintColor = R.color.mainRed()
        self.sortedBtn.addTarget(self, action: #selector(sorted(btn:)), for: .touchUpInside)
        
        self.wallBtn.setImageForAllStates(UIImage.init(named: "greatwall")!.tintImage)
        self.wallBtn.tintColor = R.color.mainRed()
        self.wallBtn.addTarget(self, action: #selector(showNeedVpnAlert), for: .touchUpInside)
        self.wallBtn.isHidden = true
	}
	
}
