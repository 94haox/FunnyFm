//
//  DownloadListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/12.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class DownloadListViewController: BaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.titleLB.text = "下载列表"
		self.view.addSubview(self.tableview)
		self.tableview.reloadData()
		self.view.insertSubview(self.tableview, at: 0)
		self.tableview.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.bottom.equalToSuperview()
			make.top.equalTo(self.topBgView.snp.bottom)
		}
	}
	
	
	
	
	lazy var tableview : UITableView = {
		let table = UITableView.init(frame: CGRect.zero, style: .plain)
		let nib = UINib(nibName: String(describing: DownloadTableViewCell.self), bundle: nil)
		table.register(nib, forCellReuseIdentifier: "tablecell")
//		table.separatorStyle = .none
		table.rowHeight = 85
		table.delegate = self
		table.dataSource = self
//		table.emptyDataSetSource = self
		table.showsVerticalScrollIndicator = false
		return table
	}()

	
}


extension DownloadListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
}


extension DownloadListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DownloadManager.shared.downloadQueue.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! DownloadTableViewCell
		let taskList = DownloadManager.shared.downloadQueue
		let task = taskList[indexPath.row]
		cell.config(task: task)
		return cell
	}
	
	
	
}
