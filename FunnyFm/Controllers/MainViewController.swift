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
//import GoogleMobileAds
//import YBTaskScheduler


class MainViewController:  BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
	
    var vm = MainViewModel.init()
	
	var scheduler = YBTaskScheduler.init(strategy: YBTaskSchedulerStrategy.FIFO)
    
    var containerView: UIView!
    
    var collectionView : UICollectionView!
    
    var tableview : UITableView!
    
    var searchBtn : UIButton!
	
	var addBtn : UIButton!
	
	var emptyView: UIView!
	
//	var avatarView: UIImageView!
	
	var loadAnimationView : AnimationView!
	
	var emptyAnimationView : AnimationView!
	
	var fetchLoadingView : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white
		self.dw_addViews()
		self.addConstrains()
		self.addHeader();
		self.loadAnimationView.play()
		self.dw_addNofications()
		self.vm.delegate = self
		self.addEmptyViews()
		
		if !UserDefaults.standard.bool(forKey: "kisFirstMain") {
			let emptyVC = EmptyMainViewController.init()
			self.navigationController?.pushViewController(emptyVC, animated: false)
			UserDefaults.standard.set(true, forKey: "kisFirstMain")
		}
		
		FeedManager.shared.delegate = self;
		FeedManager.shared.getAllPods()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.emptyAnimationView.play()
		self.loadAnimationView.play()
		self.vm.getAd(vc: self)
		FeedManager.shared.delegate = self;
	}
	
}


// MARK: - Actions
extension MainViewController{
    
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
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name.init(kParserNotification), object: nil, queue: OperationQueue.main) { (notify) in
			self.vm.refresh()
		}
	}
}


// MARK: - ViewModelDelegate
extension MainViewController : MainViewModelDelegate, FeedManagerDelegate {
	func viewModelDidGetChapterlistSuccess() {
		
	}
	
	func feedManagerDidParserPodcasrSuccess() {
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
	
	func feedManagerDidGetEpisodelistSuccess() {
		self.perform(#selector(reloadData), with: nil, afterDelay: 1, inModes: [.default])
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

		FMToolBar.shared.isHidden = false
		FMToolBar.shared.configToolBarAtHome(item as! Episode)
    }
}


// MARK: - TablviewDataSource
extension MainViewController{
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return FeedManager.shared.episodeList.count
	}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let episodeList = FeedManager.shared.episodeList[section]
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
		return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		let episodeList = FeedManager.shared.episodeList.safeObj(index: indexPath.section)
		if episodeList.isNone {
			return
		}
		let list = episodeList as! [Episode]
		let item = list.safeObj(index: indexPath.row)
		if item.isNone {
			return
		}
		
		if item is Episode{
			guard let cell = cell as? HomeAlbumTableViewCell else { return }
			let episode = item as! Episode
			cell.configHomeCell(episode)
			cell.tranferNoParameterClosure { [weak self] in
				self?.toDetail(episode: episode)
			}
			
			cell.tapLogoGesAction { [weak self] in
				let pod = DatabaseManager.getItunsPod(collectionId: episode.collectionId)
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
		view.backgroundColor = .white
		let episode = episodeList.first! as! Episode
		let titleLB = UILabel.init(text: episode.pubDate)
		titleLB.textColor = CommonColor.content.color
		titleLB.font = p_bfont(12)
		view.addSubview(titleLB)
		titleLB.snp.makeConstraints { (make) in
			make.center.equalTo(view)
		}
		
		let line = UIView.init()
		line.backgroundColor = CommonColor.mainRed.color
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
		if pod.collectionId.length() < 1 {
			return
		}
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
		label.backgroundColor = .white
		self.tableview.tableFooterView = label
	}
    
    func addHeader(){
        let refreshControl = UIRefreshControl.init()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableview.refreshControl = refreshControl;
    }
    
    
    fileprivate func addConstrains() {
		self.view.addSubview(self.topBgView)
        self.view.addSubview(self.searchBtn)
        self.view.addSubview(self.tableview)
		self.view.addSubview(self.loadAnimationView);
		self.view.sendSubviewToBack(self.topBgView)
		self.view.sendSubviewToBack(self.tableview)
		self.view.addSubview(self.fetchLoadingView);
        
        self.searchBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 40, height: 40))
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.titleLB)
        }

                
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view.snp.topMargin)
        }
		
		self.loadAnimationView.snp.makeConstraints { (make) in
			make.center.equalTo(self.view);
			make.size.equalTo(CGSize.init(width: 100, height: 100))
		}
		
		self.fetchLoadingView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width:AdaptScale(30), height: AdaptScale(30)))
			make.centerY.equalTo(self.titleLB);
			make.left.equalTo(self.titleLB.snp.right).offset(AdaptScale(20))
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
        self.collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        let cellnib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
        self.tableview.sectionHeaderHeight = 36
        self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
		self.tableview.backgroundColor = .clear
        self.tableview.separatorStyle = .none
        self.tableview.rowHeight = 100
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.showsVerticalScrollIndicator = false
        self.tableview.contentInset = UIEdgeInsets.init(top: 35.adapt(), left: 0, bottom: 120, right: 0)
        self.tableview.tableHeaderView = self.collectionView;
		self.tableview.isHidden = true
				
        self.searchBtn = UIButton.init(type: .custom)
        self.searchBtn.setBackgroundImage(UIImage.init(named: "search"), for: .normal)
        self.searchBtn.addTarget(self, action: #selector(toSearch), for:.touchUpInside)
		
		self.titleLB.text = "最近更新".localized
		
//		self.avatarView = UIImageView.init()
//		self.avatarView.cornerRadius = 35.0/2
//		self.avatarView.isUserInteractionEnabled = true
//		let tap = UITapGestureRecognizer.init(target: self, action: #selector(toUserCenter))
//		self.avatarView.addGestureRecognizer(tap)
		
		self.loadAnimationView = AnimationView(name: "refresh")
		self.loadAnimationView.loopMode = .loop;
		
		self.emptyAnimationView = AnimationView(name:"home_empty")
		self.emptyAnimationView.loopMode = .loop;
		
		self.addBtn = UIButton.init(type: .custom)
		addBtn.setTitle("发现播客".localized, for: .normal)
		addBtn.setTitleColor(.white, for: .normal)
		addBtn.backgroundColor = CommonColor.mainRed.color
		addBtn.cornerRadius = 15.0
		addBtn.titleLabel?.font = p_bfont(14);
		addBtn.addTarget(self, action: #selector(toSearch), for: .touchUpInside)
		addBtn.addShadow(ofColor: CommonColor.mainPink.color, radius: 16, offset: CGSize.init(width: 0, height: 9), opacity: 0.6)
		
		self.emptyView = UIView.init()
		emptyView.backgroundColor = .white
		emptyView.isHidden = true
		
		self.fetchLoadingView = NVActivityIndicatorView.init(frame: CGRect.zero, type: NVActivityIndicatorType.pacman, color: CommonColor.mainRed.color, padding: 2);
    }
    
}




// MARK: - 空页面 UI 布局
extension MainViewController {
	
	func addEmptyViews(){
		self.view.addSubview(self.emptyView)
		self.emptyView.snp.makeConstraints { (make) in
			make.left.width.bottom.equalToSuperview()
			make.top.equalTo(self.topBgView.snp.bottom)
		}
		
		self.emptyView.addSubview(self.emptyAnimationView)
		self.emptyAnimationView.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().offset(-50)
			make.size.equalTo(CGSize.init(width: kScreenWidth, height: AdaptScale(150)))
		}
		
		let label = UILabel.init(text: "快来添加你的第一个播客吧".localized)
		label.textColor = .lightGray
		label.font = pfont(14);
		self.emptyView.addSubview(label)
		label.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(self.emptyAnimationView.snp.bottom).offset(15)
		}
		
		self.emptyView.addSubview(self.addBtn);
		self.addBtn.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(label.snp.bottom).offset(40)
//			make.width.equalTo(180)
			make.width.equalToSuperview().offset(-100)
			make.height.equalTo(50)
		}
		
		self.emptyAnimationView.play()
		
	}
	
}


