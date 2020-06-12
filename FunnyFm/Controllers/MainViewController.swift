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


class MainViewController:  FirstViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate{
	
    var vm = MainViewModel()
    
    let guideView = GuideTipView.init(frame: CGRect.zero)
	
	let calendarCard = CalendarCard(frame: CGRect.zero)
    
    var collectionView : UICollectionView!
    
    var tableview : UITableView!
	
	var loadAnimationView : AnimationView!
	
	var fetchLoadingView : AnimationView!
	
    var emptyView: MainEmptyView = MainEmptyView.init(frame: CGRect.zero)
	
	var headers = [Int: UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = CommonColor.white.color
		self.dw_addViews()
		self.addConstrains()
		self.addHeader()
		self.addFooter()
		self.dw_addNofications()
		self.vm.delegate = self
		self.addEmptyViews()
        self.guideActions()
		vm.getDatasource(tableView: self.tableview)
				
		FeedManager.shared.delegate = self;
		self.fetchLoadingView.isHidden = !FeedManager.shared.launchParser()
        AdsManager.shared.loadAds(viewController: self)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		ClientConfig.shared.tabbarVC.title = "最近更新".localized
        if DatabaseManager.allItunsPod().count < 1 {
            self.loadAnimationView.play()
            self.emptyView.emptyAnimationView.play()
            self.addEmptyViews()
        }
		
		if !self.fetchLoadingView.isHidden {
			self.fetchLoadingView.play()
		}
		FeedManager.shared.delegate = self;
		self.navigationController?.setNavigationBarHidden(true, animated: true)
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
		self.fetchLoadingView.isHidden = false
		self.fetchLoadingView.play()
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
		self.vm.updateData(FeedManager.shared.episodeList)
		self.collectionView.reloadData()
		self.emptyView.isHidden = DatabaseManager.allItunsPod().count > 0
	}
	
	func dw_addNofications(){
		NotificationCenter.default.addObserver(forName: Notification.homeParserSuccess, object: nil, queue: OperationQueue.main) { (notify) in
			self.fetchLoadingView.isHidden = true
		}
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name.init("homechapterParserBegin"), object: nil, queue: OperationQueue.main) { (notify) in
			self.fetchLoadingView.isHidden = false
			self.fetchLoadingView.play()
		}
		
		NotificationCenter.default.addObserver(forName: Notification.Name.init(kParserNotification), object: nil, queue: OperationQueue.main) { (notify) in
			self.vm.refresh()
		}
		
		NotificationCenter.default.addObserver(forName: Notification.willAddPrevPodcast, object: nibName, queue: OperationQueue.main) { (notify) in
			self.reloadData()
		}
		
		NotificationCenter.default.addObserver(forName: Notification.singleParserSuccess, object: nibName, queue: OperationQueue.main) { (notify) in
			self.reloadData()
		}
		
		NotificationCenter.default.addObserver(forName: Notification.didUnSubscribe, object: nil, queue: OperationQueue.main) { (notify) in
			self.reloadData()
		}
	}
}


// MARK: - ViewModelDelegate
extension MainViewController : MainViewModelDelegate, FeedManagerDelegate {
	
	func toPodcastDetail(podcast: iTunsPod) {
		let vc = PodDetailViewController.init(pod: podcast)
		self.navigationController?.pushViewController(vc)
	}
	
	func toEpisodeDetail(episode: Episode) {
		self.toDetail(episode: episode)
	}
	
	func viewModelDidGetChapterlistSuccess() {
		
	}
	
	func feedManagerDidParserPodcasrSuccess() {
		perform(#selector(reloadData))
	}
	
    
    func viewModelDidGetDataSuccess() {
        self.collectionView.reloadData()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
		self.fetchLoadingView.isHidden = true
		self.loadAnimationView.removeFromSuperview()
        self.tableview.refreshControl?.endRefreshing()
        SwiftNotice.noticeOnStatusBar("请求失败".localized, autoClear: true, autoClearTime: 2)
    }
	
    func feedManagerDidGetEpisodelistSuccess(count: Int) {
		guard count > 0 else {
			return
		}
		perform(#selector(reloadData))
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
		guard let item = self.vm.dataSource.itemIdentifier(for: indexPath) else {
			return
		}
//		self.toDetail(episode: item)
		FMToolBar.shared.isHidden = false
		FMToolBar.shared.configToolBarAtHome(item)
    }
}


// MARK: - TablviewDataSource
extension MainViewController{
	    
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return getHeader(section: section)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 5
	}
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard let cell = self.tableview.visibleCells.first, let index = self.tableview.indexPath(for: cell) else {
			return
		}
		let episodeList = self.vm.episodeList[index.section]
		let episode = episodeList.first!
		self.calendarCard.config(dateString: episode.pubDate)
	}
	
	func getHeader(section: Int) -> UIView {
		guard headers[section] == nil else {
			return headers[section]!
		}
		let view = UIView()
		let cornerView = UIView()
		view.backgroundColor = R.color.ffWhite()
		cornerView.backgroundColor = R.color.mainRed()
		cornerView.cornerRadius = 3/2.0
		view.addSubview(cornerView)
		cornerView.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.size.equalTo(CGSize(width: 10, height: 3))
		}
		headers[section] = view
		return view
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
		let label = UILabel.init(text: "- only last 50 -")
		label.textColor = R.color.subtitle()
		label.textAlignment = .center
		label.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 36);
		label.font = h_bfont(14)
//		label.backgroundColor = CommonColor.white.color
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
		self.topBgView.addSubview(self.calendarCard)
        
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
		
		self.calendarCard.snp.makeConstraints { (make) in
			make.leading.equalTo(self.titleLB)
			make.bottom.equalToSuperview().offset(-2.auto())
			make.size.equalTo(CGSize(width: 35.auto(), height: 40.auto()))
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
            make.size.equalTo(CGSize(width: 40.auto(), height: 40.auto()))
			make.centerY.equalTo(self.calendarCard);
			make.left.equalTo(self.calendarCard.snp_rightMargin).offset(20.auto())
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
		let normalnib = UINib(nibName: "HomeAlbumTableViewCell", bundle: Bundle.main)
        self.tableview.sectionHeaderHeight = 36
        self.tableview.register(cellnib, forCellReuseIdentifier: "cell")
		self.tableview.register(normalnib, forCellReuseIdentifier: "normal")
        self.tableview.register(UINib.init(nibName: "AdTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "adCell")
		self.tableview.backgroundColor = .clear
        self.tableview.separatorStyle = .none
        self.tableview.delegate = self
        self.tableview.showsVerticalScrollIndicator = false
        self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: toolbarH*2, right: 0)
        self.tableview.tableHeaderView = self.collectionView;
		self.tableview.isHidden = true
		
		self.titleLB.isHidden = true
		self.loadAnimationView = AnimationView(name: "refresh")
		self.loadAnimationView.loopMode = .loop;
		
		self.fetchLoadingView = AnimationView(name: "lf30_editor_aDuarQ")
		self.fetchLoadingView.loopMode = .loop;
		self.fetchLoadingView.tintColor = R.color.mainRed()
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


