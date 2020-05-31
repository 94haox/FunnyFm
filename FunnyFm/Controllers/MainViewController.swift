//
//  ViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import SnapKit
import Lottie
import NVActivityIndicatorView
import SafariServices


class MainViewController:  BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
	
    var vm = MainViewModel.init()
    
    let guideView = GuideTipView.init(frame: CGRect.zero)
    
    var collectionView : UICollectionView!
    
    var tableview : UITableView!
	
	var loadAnimationView : AnimationView!
	
	var fetchLoadingView : NVActivityIndicatorView!
	
    var emptyView: MainEmptyView = MainEmptyView.init(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = CommonColor.white.color
		self.dw_addViews()
		self.addConstrains()
		self.addHeader();
		self.dw_addNofications()
		self.vm.delegate = self
		self.addEmptyViews()
        self.guideActions()
		
		if !UserDefaults.standard.bool(forKey: "kisFirstMain") {
			let emptyVC = EmptyMainViewController.init()
			self.navigationController?.pushViewController(emptyVC, animated: false)
			UserDefaults.standard.set(true, forKey: "kisFirstMain")
		}
		
		FeedManager.shared.delegate = self;
		FeedManager.shared.launchParser()
        AdsManager.shared.loadAds(viewController: self)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        if DatabaseManager.allItunsPod().count < 1 {
            self.loadAnimationView.play()
            self.emptyView.emptyAnimationView.play()
            self.addEmptyViews()
        }
		FeedManager.shared.delegate = self;   
	}
	
}


// MARK: - Actions
extension MainViewController{
    
    func guideActions() {
        self.guideView.readClosure = {
            let vc = SFSafariViewController.init(url: URL.init(string: "https://live.funnyfm.top/#/guide")!)
            self.present(vc, animated: true, completion: nil)
        }
        
        self.guideView.closeClosure = { [weak self] in
            self?.guideView.alpha = 0
            self?.guideView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            
            UIView.animate(withDuration: 0.2) {
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func toUserCenter() {
        let usercenterVC = UserCenterViewController()
        self.navigationController?.pushViewController(usercenterVC)
    }
    
    @objc func toSearch() {
		let search = SearchViewController.init()
		self.navigationController?.pushViewController(search);
	}
	
	func toDetail(episode: Episode) {
		let detailVC = EpisodeInfoViewController.init()
		detailVC.episode = episode
		self.navigationController?.dw_presentAsStork(controller: detailVC, heigth: kScreenHeight * 0.8, delegate: self)
	}
    
    @objc func refreshData(){
		self.fetchLoadingView.startAnimating()
        let feedBackGenertor = UIImpactFeedbackGenerator.init(style: .medium)
        feedBackGenertor.impactOccurred()
        self.vm.refresh()
    }
	
	@objc func toDiscovery(){
        if ClientConfig.shared.isIPad {
            ClientConfig.shared.masterVC.changeViewController(to: 1)
        }else{
            ClientConfig.shared.tabbarVC.changeViewController(to: 1)
        }
	}
	
	@objc func reloadData(){
		self.tableview.isHidden = false
		self.loadAnimationView.removeFromSuperview()
		if self.tableview.refreshControl!.isRefreshing {
			self.tableview.refreshControl?.endRefreshing()
		}
		self.tableview.reloadData()
		self.collectionView.reloadData()
		self.emptyView.isHidden = FeedManager.shared.podlist.count > 0
	}
	
	func dw_addNofications(){
		NotificationCenter.default.addObserver(forName: Notification.homeParserSuccess, object: nil, queue: OperationQueue.main) { (notify) in
			self.fetchLoadingView.stopAnimating()
		}
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name.init("homechapterParserBegin"), object: nil, queue: OperationQueue.main) { (notify) in
			self.fetchLoadingView.startAnimating()
		}
		
		NotificationCenter.default.addObserver(forName: Notification.Name.init(kParserNotification), object: nil, queue: OperationQueue.main) { (notify) in
			self.vm.refresh()
		}
		
		NotificationCenter.default.addObserver(forName: Notification.willAddPrevPodcast, object: nibName, queue: OperationQueue.main) { (notify) in
			FeedManager.shared.delegate = self
		}
	}
}


// MARK: - ViewModelDelegate
extension MainViewController : MainViewModelDelegate, FeedManagerDelegate {
	func viewModelDidGetChapterlistSuccess() {
		
	}
	
	func feedManagerDidParserPodcasrSuccess() {
        perform(#selector(reloadData))
	}
	
    
    func viewModelDidGetDataSuccess() {
        self.collectionView.reloadData()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
		self.fetchLoadingView.stopAnimating()
		self.loadAnimationView.removeFromSuperview()
        self.tableview.refreshControl?.endRefreshing()
        SwiftNotice.noticeOnStatusBar("请求失败".localized, autoClear: true, autoClearTime: 2)
    }
	
    func feedManagerDidGetEpisodelistSuccess(count: Int) {
        if count > 0 {
            perform(#selector(reloadData))
        }
	}
	
	func viewModelDidGetAdlistSuccess() {
		
	}
    
}

// MARK: UICollectionViewDelegate
extension MainViewController{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let pod = FeedManager.shared.podlist.safeObj(index: indexPath.row)
		if pod.isNone {
			collectionView.reloadData()
			return
		}
        let vc = PodDetailViewController.init(pod: pod as! iTunsPod)
        self.navigationController?.pushViewController(vc)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let episodeList = FeedManager.shared.episodeList.safeObj(index: indexPath.section)
		if episodeList.isNone {
			tableView.reloadData()
			return
		}
		let list = episodeList as! [Episode]
		let item = list.safeObj(index: indexPath.row)
		if  item.isNone {
			tableView.reloadData()
			return
		}

		guard item is Episode else {
			return;
		}
		self.toDetail(episode: item as! Episode)
//		FMToolBar.shared.isHidden = false
//		FMToolBar.shared.configToolBarAtHome(item as! Episode)
    }
}


// MARK: - TablviewDataSource
extension MainViewController{
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return FeedManager.shared.episodeList.count
	}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let episodeList = FeedManager.shared.episodeList[section]
        if AdsManager.shared.expressAdViews.count > 0{
            return episodeList.count + 1
        }
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episodeList = FeedManager.shared.episodeList.safeObj(index: indexPath.section)
        let list = episodeList as! [Episode]
        if indexPath.row > list.count - 1, AdsManager.shared.expressAdViews.count > indexPath.section{
            let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AdTableViewCell
            let ads = AdsManager.shared.expressAdViews[indexPath.section]
            cell.render(ads: ads)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EpisodeCardTableViewCell
		return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		let episodeList = FeedManager.shared.episodeList.safeObj(index: indexPath.section) as? [Episode]
		guard let list = episodeList else {
			return
		}
        
        if indexPath.row > list.count {
            return
        }
        
		let item = list.safeObj(index: indexPath.row)
		if item.isNone {
			return
		}
		
		if item is Episode{
			guard let cell = cell as? EpisodeCardTableViewCell else { return }
			let episode = item as! Episode
			cell.configHomeCell(episode)
			cell.tapLogoClosure = { [weak self] in
				let pod = DatabaseManager.getPodcast(feedUrl: episode.podcastUrl)
				if pod.isSome {
					let vc = PodDetailViewController.init(pod: pod!)
					self?.navigationController?.pushViewController(vc)
				}
			}
		}
		
    }
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if FeedManager.shared.episodeList.count-1 < section {
			return nil;
		}
		let episodeList = FeedManager.shared.episodeList[section]
		let view = UIView.init()
		view.backgroundColor = CommonColor.white.color
		let episode = episodeList.first! as! Episode
		let titleLB = UILabel.init(text: episode.pubDate)
		titleLB.textColor = CommonColor.content.color
		titleLB.font = p_bfont(12)
		view.addSubview(titleLB)
		titleLB.snp.makeConstraints { (make) in
			make.center.equalTo(view)
		}
		
		let line = UIView.init()
		line.backgroundColor = R.color.mainRed()!
		view.addSubview(line)
		line.snp.makeConstraints { (make) in
			make.centerX.equalTo(view)
			make.top.equalTo(titleLB.snp.bottom).offset(2)
			make.height.equalTo(3)
			make.width.equalTo(10)
		}
		return view
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


// MARK: UICollectionViewDataSource
extension MainViewController{
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return FeedManager.shared.podlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = HomePodListHeader()
        if kind == UICollectionView.elementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath) as! HomePodListHeader;
            header.tapClosure = {
                let podlistvc = PodListViewController()
                self.navigationController?.pushViewController(podlistvc)
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? HomePodCollectionViewCell else { return }
		let item = FeedManager.shared.podlist.safeObj(index: indexPath.row)
		if item.isNone {
			return
		}
		let pod = item as! iTunsPod
        cell.configCell(pod)
    }
}


// MARK: - UI
extension MainViewController {
	
	func addFooter(){
		let label = UILabel.init(text: "- only last 15 -")
		label.textColor = UIColor.init(hex: "e0e2e6")
		label.textAlignment = .center
		label.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 36);
		label.font = h_bfont(14)
		label.backgroundColor = CommonColor.white.color
		self.tableview.tableFooterView = label
	}
    
    func addHeader(){
        let refreshControl = UIRefreshControl.init()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableview.refreshControl = refreshControl;
    }
    
    
    fileprivate func addConstrains() {
		self.view.addSubview(self.topBgView)
        self.view.addSubview(self.tableview)
		self.view.addSubview(self.loadAnimationView);
		self.view.sendSubviewToBack(self.topBgView)
		self.view.sendSubviewToBack(self.tableview)
		self.view.addSubview(self.fetchLoadingView);
        self.view.addSubview(self.guideView)
        
        self.guideView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-20.auto())
            make.top.equalTo(self.topBgView.snp_bottom)
            if UserDefaults.standard.bool(forKey: "GuideisShowed") {
                guideView.isHidden = true
                make.height.equalTo(0)
            }else{
                make.height.equalTo(130.auto())
            }
        }
                
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.guideView.snp_bottom)
        }
		
		self.loadAnimationView.snp.makeConstraints { (make) in
			make.center.equalTo(self.view);
			make.size.equalTo(CGSize.init(width: 100, height: 100))
		}
		
		self.fetchLoadingView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width:30.auto(), height: 30.auto()))
			make.centerY.equalTo(self.titleLB);
            make.left.equalTo(self.titleLB.snp.right).offset(20.auto())
		}		
    }
    
    func dw_addViews(){
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 65, height: 65)
        layout.headerReferenceSize = CGSize(width: 95, height: 65)
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 80), collectionViewLayout: layout)
        self.collectionView.showsHorizontalScrollIndicator = false
        let nib = UINib(nibName: String(describing: HomePodCollectionViewCell.self), bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.register(HomePodListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView.backgroundColor = CommonColor.white.color
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        let cellnib = UINib(nibName: "EpisodeCardTableViewCell", bundle: Bundle.main)
        self.tableview.sectionHeaderHeight = 36
        self.tableview.register(cellnib, forCellReuseIdentifier: "cell")
        self.tableview.register(UINib.init(nibName: "AdTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "adCell")
		self.tableview.backgroundColor = .clear
        self.tableview.separatorStyle = .none
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.showsVerticalScrollIndicator = false
        self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: toolbarH*2, right: 0)
        self.tableview.tableHeaderView = self.collectionView;
		self.tableview.isHidden = true
		
		self.titleLB.text = "最近更新".localized
		
		self.loadAnimationView = AnimationView(name: "refresh")
		self.loadAnimationView.loopMode = .loop;
		
		self.fetchLoadingView = NVActivityIndicatorView.init(frame: CGRect.zero, type: NVActivityIndicatorType.pacman, color: R.color.mainRed()!, padding: 2);
    }
    
}




// MARK: - 空页面 UI 布局
extension MainViewController {
	
	func addEmptyViews(){
        self.emptyView.isHidden = DatabaseManager.allItunsPod().count > 0
        self.view.addSubview(self.emptyView)
        self.view.bringSubviewToFront(self.guideView)
        self.emptyView.snp.makeConstraints { (make) in
            make.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.guideView.snp_bottom)
        }
        
        self.emptyView.actionBlock = { [weak self] in
            self?.toDiscovery()
        }
    
	}
	
}


