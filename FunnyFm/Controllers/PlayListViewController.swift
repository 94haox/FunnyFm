//
//  PlayListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/28.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class PlayListViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "播放列表".localized
		self.view.backgroundColor = CommonColor.background.color
        self.view.addSubview(self.tableview)
		self.tableview.reloadData()
		self.view.insertSubview(self.tableview, at: 0)
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.topBgView.snp.bottom)
        }

    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		DispatchQueue.main.async {
			PlayListManager.shared.updatePlayQueue()
			self.tableview.reloadData()
		}
	}

	lazy var tableview : UITableView = {
		   let table = UITableView.init(frame: CGRect.zero, style: .plain)
		   let nib = UINib(nibName: String(describing: HistoryTableViewCell.self), bundle: nil)
		   table.register(nib, forCellReuseIdentifier: "cell")
		   table.separatorStyle = .none
		   table.rowHeight = 85
		   table.delegate = self
		   table.dataSource = self
//		   table.emptyDataSetSource = self
		   table.showsVerticalScrollIndicator = false
		   table.backgroundColor = .white
		   return table
	   }()

}

extension PlayListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}

extension PlayListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return PlayListManager.shared.playQueue.count - 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let itemCell = cell as! HistoryTableViewCell
		let episode = PlayListManager.shared.playQueue[indexPath.row + 1]
		itemCell.config(episode: episode)
	}
}
