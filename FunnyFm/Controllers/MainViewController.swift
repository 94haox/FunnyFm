//
//  ViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import SnapKit
import SPStorkController
import Lottie

class MainViewController:  BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var vm = MainViewModel.init()
    
    var containerView: UIView!
    
    var collectionView : UICollectionView!
    
    var tableview : UITableView!
    
    var searchBar : FMTextField!
    
    var searchBtn : UIButton!
    
    var profileBtn : UIButton!
	
	var loadAnimationView : AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white
        self.vm.delegate = self
        self.vm.getAllPods()
        self.vm.getHomeChapters()
		self.dw_addViews()
		self.addConstrains()
		self.addHeader();
		self.addFooter()
		self.loadAnimationView.play()
		UIApplication.shared.keyWindow?.addSubview(FMToolBar.shared)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		FMToolBar.shared.explain()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		FMToolBar.shared.shrink()
	}
	
}


// MARK: - Actions
extension MainViewController{
    
    @objc func toUserCenter() {
        let usercenterVC = UserCenterViewController()
        self.navigationController?.pushViewController(usercenterVC)
    }
    
    @objc func toSearch() {
//        let login = NeLoginViewController()
//        self.navigationController?.pushViewController(login)
//		let preview = PodPreviewViewController()
//		preview.modalPresentationStyle = .overCurrentContext
//		self.present(preview, animated: false, completion: nil)
		let search = SearchViewController.init()
		self.navigationController?.pushViewController(search);
//		FeedManager.shared.parserRss(url: "https://rsshub.app/ncm/djradio/348319107")
    }
    
    @objc func refreshData(){
        let feedBackGenertor = UIImpactFeedbackGenerator.init(style: .medium)
        feedBackGenertor.impactOccurred()
        self.vm.refresh()
    }
}


// MARK: - ViewModelDelegate
extension MainViewController : ViewModelDelegate {
    
    func viewModelDidGetDataSuccess() {
		self.tableview.isHidden = false
		self.loadAnimationView.removeFromSuperview()
        self.tableview.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
        self.tableview.reloadData()
        if self.vm.chapterList.count > 0  && !FMToolBar.shared.isPlaying{
            FMToolBar.shared.configToolBarAtHome(self.vm.chapterList.first!)
        }
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
		self.loadAnimationView.removeFromSuperview()
        self.tableview.refreshControl?.endRefreshing()
        SwiftNotice.noticeOnStatusBar("请求失败", autoClear: true, autoClearTime: 2)
    }
    
}

// MARK: UICollectionViewDelegate
extension MainViewController{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pod = self.vm.podlist[indexPath.row]
        let vc = EpisodeListViewController.init(pod)
        self.navigationController?.pushViewController(vc)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapter = self.vm.chapterList[indexPath.row]
        FMToolBar.shared.configToolBarAtHome(chapter)
    }
}


// MARK: - TablviewDataSource
extension MainViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.chapterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeAlbumTableViewCell else { return }
        let chapter = self.vm.chapterList[indexPath.row]
        cell.configHomeCell(chapter)
    }
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel.init(text: "最近更新")
		label.textColor = UIColor.init(hex: "e0e2e6")
		label.textAlignment = .center
		label.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 36);
		label.font = p_bfont(14)
		label.backgroundColor = .white
		return label
	}
	
	

}


// MARK: UICollectionViewDataSource
extension MainViewController{
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return self.vm.podlist.count
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
        let index = indexPath.row % self.vm.podlist.count
        let pod = self.vm.podlist[index]
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
        self.view.addSubview(self.profileBtn)
        self.view.addSubview(self.searchBtn)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableview)
		self.view.addSubview(self.loadAnimationView);
        
        self.profileBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 35, height: 35))
            make.left.equalToSuperview().offset(32)
            make.centerY.equalTo(self.searchBar)
        }
        
        self.searchBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 40, height: 40))
            make.right.equalToSuperview().offset(-32)
            make.centerY.equalTo(self.searchBar)
        }
        
        self.searchBar.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(self.profileBtn.snp.right).offset(32)
            make.right.equalTo(self.searchBtn.snp.left).offset(-16)
            make.top.equalTo(self.view.snp.topMargin)
        }
                
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.searchBar.snp.bottom).offset(32)
        }
		
		self.loadAnimationView.snp.makeConstraints { (make) in
			make.center.equalTo(self.view);
			make.size.equalTo(CGSize.init(width: 100, height: 100))
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
        self.tableview.separatorStyle = .none
        self.tableview.rowHeight = 100
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.showsVerticalScrollIndicator = false
        self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
        self.tableview.tableHeaderView = self.collectionView;
		self.tableview.isHidden = true
        
        self.searchBtn = UIButton.init(type: .custom)
        self.searchBtn.setBackgroundImage(UIImage.init(named: "search"), for: .normal)
        self.searchBtn.addTarget(self, action: #selector(toSearch), for:.touchUpInside)
        
        self.searchBar = FMTextField.init(frame: CGRect.zero)
        self.searchBar.cornerRadius = 15;
        self.searchBar.tintColor = CommonColor.mainRed.color
        self.searchBar.backgroundColor = CommonColor.cellbackgroud.color
        self.searchBar.returnKeyType = .done
        self.searchBar.font = pfont(fontsize4)
        self.searchBar.textColor = CommonColor.title.color
        self.searchBar.delegate = self.searchBar
		self.searchBar.attributedPlaceholder = FunnyFm.attributePlaceholder("search")
        
        self.profileBtn = UIButton.init(type: .custom)
        self.profileBtn.setBackgroundImage(UIImage.init(named: "profile"), for: .normal)
        self.profileBtn.addTarget(self, action: #selector(toUserCenter), for:.touchUpInside)
		
		self.loadAnimationView = AnimationView(name: "refresh")
		self.loadAnimationView.loopMode = .loop;
    }
    
}


