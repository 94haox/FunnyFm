//
//  ChapterListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit


class EpisodeListViewController: BaseViewController , ViewModelDelegate, UITableViewDelegate,UITableViewDataSource{

    var vm: ChapterListViewModel!
	
	var topBar: PodDetailTopBar!
	
	var topView: PodCastCoverView!
    
    var pod: Pod!
    
    var chapterTable: UITableView!
    
    init(_ pod: Pod) {
        super.init(nibName: nil, bundle: nil)
        self.pod = pod
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI(self.pod)
        self.addHeader()
        self.addConstrains()
        self.tableview.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        let mjFooter = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        mjFooter?.triggerAutomaticallyRefreshPercent = 0.5;
        mjFooter!.ignoredScrollViewContentInsetBottom = 100.0
        self.tableview.mj_footer = mjFooter;
    }
	
	func setupUI(_ pod: Pod){
		self.vm = ChapterListViewModel.init(pod.albumId)
		self.vm.delegate = self
		self.topBar = PodDetailTopBar.init(frame: CGRect.zero)
		self.topView = PodCastCoverView.init(frame: CGRect.zero)
		self.topView.config(pod)
		self.topBar.config(pod)
		self.topBar.alpha = 0
        
	}
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: "tablecell")
        table.separatorStyle = .none
        table.rowHeight = 131
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsets.init(top: 220, left: 0, bottom: 0, right: 0)
        return table
    }()

}

/// MARK: Actions
extension EpisodeListViewController {
    
    @objc func refreshAction(){
        self.vm.first()
        self.tableview.mj_footer.resetNoMoreData()
    }
    
    @objc func loadMore(){
        self.vm.next()
    }
    
}


// MARK: - network delegate
extension EpisodeListViewController{
    
    func viewModelDidGetDataSuccess() {
        if self.vm.isNoMore {
            self.tableview.mj_footer.endRefreshingWithNoMoreData()
        }else{
            self.tableview.mj_footer.endRefreshing()
        }
        self.tableview.mj_header.endRefreshing()

        self.tableview.reloadData()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        self.tableview.mj_header.endRefreshing()
        self.tableview.mj_footer.endRefreshing()
    }
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		var offsetY = scrollView.contentOffset.y
		
		if offsetY > 0{
			offsetY = 0
		}
		
		if abs(offsetY) > 260{
			offsetY = -260
		}
		self.topView.snp.updateConstraints { (make) in
			make.bottom.equalTo(self.view.snp.top).offset(abs(offsetY))
		}
		
		let alpha = offsetY == 0 ? 1 : 0
		if  CGFloat.init(alpha) != self.topBar.alpha {
			UIView.animate(withDuration: 0.1) {
				self.topBar.alpha = CGFloat.init(alpha)
			}
		}
		
	}

    
}


// MARK: UITableViewDelegate

extension EpisodeListViewController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapter = self.vm.chapterList[indexPath.row]
        FMToolBar.shared.configToolBar(chapter)
    }
	
}

// MARK: - UITableViewDataSource
extension EpisodeListViewController{
    
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
        cell.configCell(chapter)
    }
    
    
}

// MARK: - UI
extension EpisodeListViewController {
    
    func addHeader(){
        let header = UILabel.init(text: "   最近更新")
        header.textColor = CommonColor.content.color
        header.font = p_bfont(fontsize4)
        header.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 30)
        self.tableview.tableHeaderView = header;
    }
    
    fileprivate func addConstrains() {
	
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableview)
		self.view.addSubview(self.topView)
		self.view.addSubview(self.topBar)
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view)
        }
		
		self.topView.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.height.equalTo(260)
			make.bottom.equalTo(self.view.snp.top).offset(260)
		}
		
		self.topBar.snp.makeConstraints { (make) in
			make.top.equalTo(self.view.snp.topMargin)
			make.width.equalToSuperview().offset(-132)
			make.height.equalTo(70)
			make.centerX.equalToSuperview()
		}
    }
    
}

