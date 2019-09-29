//
//  PlayListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/8/28.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlayListViewController: BaseViewController {
	var tipLB: UILabel = UILabel.init(text: "待播:".localized)
	var countLB: UILabel = UILabel.init(text: "0")

    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "播放列表".localized
		self.view.backgroundColor = CommonColor.background.color
		self.setupUI()
    }
    
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		PlayListManager.shared.updatePlayQueue()
		DispatchQueue.main.async {
			if (PlayListManager.shared.playQueue.count - 1) > 0{
				self.countLB.isHidden = false
				self.tipLB.isHidden = false
				self.countLB.text = String(PlayListManager.shared.playQueue.count - 1)
			}else{
				self.countLB.isHidden = true
				self.tipLB.isHidden = true
			}
			let indexSet = IndexSet.init(integer: 0)
			self.tableview.reloadSections(indexSet, with: UITableView.RowAnimation.fade)
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
		   table.emptyDataSetSource = self
		   table.showsVerticalScrollIndicator = false
		   table.backgroundColor = .white
		   table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
		   return table
	   }()

}

extension PlayListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let episode = PlayListManager.shared.playQueue[indexPath.row + 1]
		let detailVC = EpisodeInfoViewController.init()
		detailVC.episode = episode
		self.navigationController?.dw_presentAsStork(controller: detailVC, heigth: kScreenHeight * 0.6, delegate: self)
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


extension PlayListViewController {
	func setupUI(){
		self.tipLB.textColor = CommonColor.content.color
		self.tipLB.font = pfont(12)
		
		self.countLB.textColor = CommonColor.mainRed.color
		self.countLB.font = p_bfont(12)
		
		self.view.addSubview(self.tableview)
		self.view.insertSubview(self.tableview, at: 0)
		self.topBgView.addSubview(self.countLB)
		self.topBgView.addSubview(self.tipLB)
		
		self.tipLB.snp.makeConstraints { (make) in
			make.right.equalTo(self.countLB.snp.left).offset(-5.adapt())
			make.baseline.equalTo(self.titleLB)
		}
		
		self.countLB.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-16)
			make.baseline.equalTo(self.titleLB)
		}
		
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.topBgView.snp.bottom)
        }
	}
}

extension PlayListViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if scrollView.contentOffset.y > 0 {
			self.topBgView.addShadow(ofColor: CommonColor.subtitle.color, radius: 5, offset: CGSize.init(width: 0, height: 5), opacity: 0.8)
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

extension PlayListViewController {
	override func didDismissStorkByTap() {
		super.didDismissStorkByTap()
		self.viewDidAppear(true)
	}
	
	override func didDismissStorkBySwipe() {
		super.didDismissStorkBySwipe()
		self.viewDidAppear(true)
	}
}
