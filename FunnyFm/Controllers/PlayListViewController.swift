//
//  PlayListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/28.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit


class PlayListViewController: BaseViewController {
	var tipLB: UILabel = UILabel.init(text: "待播:".localized)
	var countLB: UILabel = UILabel.init(text: "0")
	var playlist: [Episode] = {
		var list = PlayListManager.shared.playQueue
		if list.count > 0 {
			list.remove(at: 0)
		}
		return list
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "播放列表".localized
		self.view.backgroundColor = CommonColor.background.color
		self.setupUI()
    }
    	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.refreshPlayQueue()
	}
	
	func refreshPlayQueue(){
		DispatchQueue.global().async {
			PlayListManager.shared.updatePlayQueue()
			DispatchQueue.main.async {
				self.refreshData()
				if (PlayListManager.shared.playQueue.count - 1) > 0{
					self.countLB.isHidden = false
					self.tipLB.isHidden = false
					self.countLB.text = String(PlayListManager.shared.playQueue.count - 1)
				}else{
					self.countLB.isHidden = true
					self.tipLB.isHidden = true
					self.countLB.text = "0"
				}
				self.tableview.reloadData()
			}
		}
	}
	
	
	func refreshData(){
		var list = PlayListManager.shared.playQueue
		if list.count > 0 {
			list.remove(at: 0)
		}
		self.playlist = list
		if list.count == 0 {
			self.tableview.emptyDataSetSource = self
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
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = CommonColor.white.color
        table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: toolbarH*2, right: 0)
        return table
	   }()

}

extension PlayListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let episode = self.playlist[indexPath.row]
		let detailVC = EpisodeInfoViewController.init()
		detailVC.episode = episode
		self.navigationController?.dw_presentAsStork(controller: detailVC, heigth: kScreenHeight * 0.6, delegate: self)
	}
	
	func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		return "从待播中移出".localized
	}
}

extension PlayListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.playlist.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let itemCell = cell as! HistoryTableViewCell
		let episode = self.playlist[indexPath.row]
        itemCell.actionBlock = { [weak self] in
            guard let currentEpisode = FMToolBar.shared.currentEpisode, currentEpisode.trackUrl == episode.trackUrl else{
                FMToolBar.shared.configToolBarAtHome(episode)
                self?.refreshPlayQueue()
                return
            }
        }
		itemCell.config(playItem: episode)
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let episode = self.playlist[indexPath.row]
			PlayListManager.shared.queueOut(episode: episode)
			self.refreshPlayQueue()
		}
	}
}


extension PlayListViewController {
	func setupUI(){
		self.tipLB.textColor = CommonColor.content.color
		self.tipLB.font = pfont(12)
		
		self.countLB.textColor = CommonColor.mainRed.color
		self.countLB.font = p_bfont(12)
		
		self.view.addSubview(self.tableview)
		self.topBgView.addSubview(self.countLB)
		self.topBgView.addSubview(self.tipLB)
		self.view.bringSubviewToFront(self.topBgView)
		
		self.tipLB.snp.makeConstraints { (make) in
			make.right.equalTo(self.countLB.snp.left).offset(-5.adapt())
			make.baseline.equalTo(self.titleLB)
		}
		
		self.countLB.snp.makeConstraints { (make) in
			make.right.equalTo(self.view).offset(-16)
			make.baseline.equalTo(self.titleLB)
		}
		
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalTo(self.view)
			make.bottom.equalTo(self.view)
            make.top.equalTo(self.topBgView.snp.bottom)
        }
	}
}

extension PlayListViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if scrollView.contentOffset.y > 0 {
			self.topBgView.addShadow(ofColor: CommonColor.subtitle.color, radius: 2, offset: CGSize.init(width: 0, height: 2), opacity: 0.8)
		}else{
			self.topBgView.addShadow(ofColor: .clear, radius: 0, offset: CGSize.init(width: 0, height: 0), opacity: 0.8)
		}
	}
}

extension PlayListViewController : DZNEmptyDataSetSource {
	
	func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		return UIImage.init(named: "download-empty")
	}
	
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		return NSAttributedString.init(string: "尚无待播单集~".localized, attributes: [NSAttributedString.Key.font: pfont(fontsize2)])
	}
	
}

//extension PlayListViewController {
//	override func didDismissStorkByTap() {
//		super.didDismissStorkByTap()
//		self.viewDidAppear(true)
//	}
//
//	override func didDismissStorkBySwipe() {
//		super.didDismissStorkBySwipe()
//		self.viewDidAppear(true)
//	}
//}
