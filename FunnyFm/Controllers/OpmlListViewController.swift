//
//  OpmlListViewController.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/6/6.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class OpmlListViewController: UIViewController {
	
	let vm: PodDetailViewModel = PodDetailViewModel()
	
	let tableview = UITableView.init(frame: CGRect.zero, style: .plain)
	
	var items: [OPMLItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = R.color.background()
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .automatic
		navigationItem.hidesBackButton = true
		self.title = "OPML"
		self.setupUI()
		self.vm.delegate = self
		let podcasts = DatabaseManager.allItunsPod()
		let feedurls = podcasts.map { (podcast) -> String in
			podcast.feedUrl
		}
		self.items?.removeAll(where: { (item) -> Bool in
			feedurls.contains(item.xmlURL!)
		})
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}

}

extension OpmlListViewController: UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OpmlTableViewCell
		let item = self.items![indexPath.row]
		cell.config(item: item)
		cell.subscribeBlock = { [weak self] in
			Hud.shared.show(on: self!.view)
			self?.vm.getPrev(feedUrl: item.xmlURL!)
		}
		return cell
	}
	
	
}

extension OpmlListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = self.items![indexPath.row]
		Hud.shared.show(on: self.view)
		self.vm.getPrev(feedUrl: item.xmlURL!)
	}
}

extension OpmlListViewController: PodDetailViewModelDelegate {
	
	func podDetailParserSuccess() {
		Hud.shared.hide()
		let preview = PodPreviewViewController()
		preview.itunsPod = self.vm.pod
		preview.subscribeBlock = { [weak self] feedUrl in
			self?.items!.removeAll { (item) -> Bool in
				item.xmlURL! == feedUrl
			}
			self?.tableview.reloadData()
		}
		self.present(preview, animated: true, completion: nil)
	}
	
	func podDetailCancelSubscribeSuccess() {
		
	}
	
	func viewModelDidGetDataSuccess() {
		self.tableview.reloadData()
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
	}
}


extension OpmlListViewController {
	
	func setupUI() {
		tableview.register(UINib.init(nibName: "OpmlTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
		tableview.separatorStyle = .none
		tableview.rowHeight = 60.auto()
		tableview.dataSource = self;
		tableview.delegate = self;
		view.addSubview(tableview)
		tableview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
	
}
