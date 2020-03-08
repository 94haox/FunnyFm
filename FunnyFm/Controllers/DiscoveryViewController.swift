//
//  DiscoveryViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/24.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import OfficeUIFabric

class DiscoveryViewController: BaseViewController {

	let rssAddView: RssAddView = RssAddView.init(frame: CGRect.zero)
	let vm: PodDetailViewModel = PodDetailViewModel()
	var tableview: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
	var searchBtn : UIButton = UIButton.init(type: .custom)
	let loadingView: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLB.text = "为您推荐".localized
		self.setupUI()
		self.dw_addConstraints()
		self.vm.delegate = self
		self.rssAddView.searchBlock = { [weak self] rss in
			MSHUD.shared.show(from: self!)
			self!.vm.getPrev(feedUrl: rss)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if self.vm.collectionList.count < 1 {
			self.vm.getAllRecommends()
		}
	}

}

// actions
extension DiscoveryViewController {
	
    @objc func toSearch() {
		let search = SearchViewController.init()
		self.navigationController?.pushViewController(search);
	}
	
}

extension DiscoveryViewController: PodDetailViewModelDelegate {
	
	func podDetailParserSuccess() {
		MSHUD.shared.hide()
		let preview = PodPreviewViewController()
		preview.itunsPod = self.vm.pod
		self.present(preview, animated: true, completion: nil)
	}
	
	func podDetailCancelSubscribeSuccess() {
		
	}
	
	func viewModelDidGetDataSuccess() {
		self.loadingView.removeFromSuperview()
		self.tableview.reloadData()
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
	}
}

extension DiscoveryViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.vm.collectionList.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiscoverListTableViewCell
		cell.config(collection: self.vm.collectionList[indexPath.section])
		cell.clickCloure = { podcast in
            let pod = DatabaseManager.getPodcast(feedUrl: podcast.feedUrl)
            if pod.isSome {
                let podvc = PodDetailViewController.init(pod: pod!)
                self.navigationController?.pushViewController(podvc)
                return
            }
			let preview = PodPreviewViewController()
			preview.itunsPod = podcast
			self.present(preview, animated: true, completion: nil)
		}
		return cell
	}
	
	
	
}

extension DiscoveryViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = DiscoverHeader.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 40))
		header.config(collection: self.vm.collectionList[section])
		header.backgroundColor = .white
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView.init()
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
}


extension DiscoveryViewController {
	
	func dw_addConstraints(){
		self.view.addSubview(self.rssAddView)
		self.view.addSubview(self.searchBtn)
		self.view.addSubview(self.tableview)
		self.view.addSubview(self.loadingView)
		
		
		self.searchBtn.snp.makeConstraints { (make) in
		   make.size.equalTo(CGSize.init(width: 40, height: 40))
		   make.right.equalToSuperview().offset(-16)
		   make.centerY.equalTo(self.titleLB)
		}
		
		self.rssAddView.snp.makeConstraints { (make) in
			make.top.equalTo(self.topBgView.snp_bottom).offset(8.auto())
			make.centerX.equalToSuperview()
			make.width.equalToSuperview().offset(-24.auto())
			make.height.equalTo(40)
		}
		
		self.tableview.snp.makeConstraints { (make) in
			make.left.width.bottom.equalToSuperview()
			make.top.equalTo(self.rssAddView.snp.bottom).offset(16.auto())
		}
		
		self.loadingView.snp.makeConstraints { (make) in
			make.center.equalTo(self.tableview)
		}
	}
	
	func setupUI(){
		
        self.searchBtn.setBackgroundImage(UIImage.init(named: "search"), for: .normal)
        self.searchBtn.addTarget(self, action: #selector(toSearch), for:.touchUpInside)
	
		self.tableview.register(DiscoverListTableViewCell.self, forCellReuseIdentifier: "cell")
		self.tableview.dataSource = self
		self.tableview.delegate = self
		self.tableview.rowHeight = 160.auto()
		self.tableview.backgroundColor = .clear
		self.tableview.separatorStyle = .none
		self.tableview.tableFooterView = UIView.init()
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
		self.tableview.showsVerticalScrollIndicator = false
		
		self.loadingView.startAnimating()
	}
	
}
