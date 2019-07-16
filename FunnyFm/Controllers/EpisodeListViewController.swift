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
	
	var podBackgroundView: UIView!
	
	var podImageView: UIImageView!
	
	var podNameLB: UILabel!
	
	var podAuthorLB: UILabel!
	
	var updateLB: UILabel!
	
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
        let mjFooter = MJRefreshBackFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        self.tableview.mj_footer = mjFooter;
    }
	
	func setupUI(_ pod: Pod){
		if pod.sourceType == "iTunes" {
			self.vm = ChapterListViewModel.init(pod.itunesId)
		}else{
			self.vm = ChapterListViewModel.init(pod.albumId)
		}
		
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
        self.tableview.reloadData()
        if self.vm.isNoMore {
            self.tableview.mj_footer.endRefreshingWithNoMoreData()
        }else{
            self.tableview.mj_footer.endRefreshing()
        }
        self.tableview.mj_header.endRefreshing()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        self.tableview.mj_header.endRefreshing()
        self.tableview.mj_footer.endRefreshing()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! HomeAlbumTableViewCell
        let chapter = self.vm.chapterList[indexPath.row]
        cell.configCell(chapter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == (self.vm.chapterList.count - 2)  {
            self.loadMore()
        }
        
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
	
	func addSubviews(){
		self.podBackgroundView = UIView.init()
		self.podBackgroundView.cornerRadius = 15
		self.view.addSubview(self.podBackgroundView)
		
		self.podImageView = UIImageView.init()
		self.podImageView.kf.setImage(with: URL.init(string: self.pod.img)!) {[unowned self] result in
			switch result {
			case .success(let value):
				self.podBackgroundView.addShadow(ofColor: value.image.mostColor(), radius: 0, offset: CGSize.init(width: 5, height: 5), opacity: 0)
			case .failure(let error):
				print("Error: \(error)")
			}
		}
		self.podImageView.cornerRadius = 15;
		self.view.addSubview(self.podImageView)

		self.podNameLB = UILabel.init(text: self.pod.name)
		self.podNameLB.textColor = CommonColor.title.color
		self.podNameLB.font = p_bfont(18)
		
		self.podAuthorLB = UILabel.init(text: self.pod.sourceType)
		self.podAuthorLB.textColor = CommonColor.content.color
		self.podAuthorLB.font = p_bfont(15)
		
		self.updateLB = UILabel.init(text: self.pod.update_time)
		self.updateLB.textColor = CommonColor.content.color
		self.updateLB.font = p_bfont(12)
		
	}
    
}

