//
//  FavouriteViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Lottie

class FavouriteListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
	
    
    var tableview: UITableView!
    
    var syncAniView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.addSubViews()
    }
    
    lazy var historyList : [Episode] = {
        return []
    }()
    
    
}

extension FavouriteListController {
    @objc func syncAction(){
        if self.syncAniView.isAnimationPlaying {
            self.syncAniView.stop()
            return
        }
        self.syncAniView.play()
        self.syncAniView.loopMode = .loop
        
    }
}


extension FavouriteListController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let history = self.historyList[indexPath.row]
        //        FMToolBar.shared.configToolBar(history)
    }
    
}

extension FavouriteListController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeAlbumTableViewCell else { return }
        let history = self.historyList[indexPath.row]
        cell.configCell(history)
    }
    
}

extension FavouriteListController : DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "favor-empty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "收藏为空哦~", attributes: [NSAttributedString.Key.font: pfont(fontsize2)])
    }
    
}

extension FavouriteListController{
    
    func addSubViews(){
        self.view.addSubview(self.tableview)
        self.view.addSubview(self.syncAniView)
        
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.titleLB.snp.bottom)
        }
        
        self.syncAniView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.titleLB).offset(8.7)
            make.size.equalTo(CGSize.init(width: 70, height: 70))
        }
    }
    
    func setupUI() {
        self.titleLB.text = "我的收藏".localized
        
        self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
        self.tableview.register(nib, forCellReuseIdentifier: "tablecell")
        self.tableview.separatorStyle = .none
        self.tableview.rowHeight = 100
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.showsVerticalScrollIndicator = false
        self.tableview.emptyDataSetSource = self;
        
        self.syncAniView = AnimationView(name: "cloud_sync")
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(syncAction))
        self.syncAniView.addGestureRecognizer(tap)
        
    }
}
