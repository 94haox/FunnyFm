//
//  DownloadListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/12.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Tiercel

class DownloadListViewController: BaseViewController {
	
	var segment: UISegmentedControl = UISegmentedControl(items: ["已下载".localized,"下载中".localized])
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "已下载".localized
		self.view.addSubview(self.tableview)
		self.segment.addTarget(self, action: #selector(changeSection), for: .valueChanged)
		self.segment.tintColor = R.color.mainRed()
		self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.deleteBtn)
		self.navigationItem.titleView = self.segment
		self.tableview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
        self.segment.selectedSegmentIndex = 0;
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.deleteBtn.isHidden = self.episodeList.count < 2
		self.tableview.reloadData()
        self.segment.isHidden = self.episodeList.count < 1 && DownloadManager.shared.downloadQueue.count < 1
	}
	
	@objc func changeSection(){
		if self.segment.selectedSegmentIndex == 1 {
			self.title = "下载中".localized
			self.deleteBtn.isHidden = true
		}else{
			self.title = "已下载".localized
			self.deleteBtn.isHidden = self.episodeList.count < 2
		}
        self.tableview.reloadData()
	}
	
	lazy var tableview : UITableView = {
		let table = UITableView.init(frame: CGRect.zero, style: .plain)
		let nib = UINib(nibName: String(describing: DownloadTableViewCell.self), bundle: nil)
		table.register(nib, forCellReuseIdentifier: "tablecell")
        table.separatorStyle = .none
		table.rowHeight = 85
		table.delegate = self
		table.dataSource = self
		table.emptyDataSetSource = self
		table.showsVerticalScrollIndicator = false
		table.tableFooterView = UIView()
		table.backgroundColor = CommonColor.white.color
		return table
	}()
	
    var episodeList : [Episode] {
        get {
            return DatabaseManager.allDownload().reversed()
        }
    }
	
	var downloadTasks: [DownloadTask] {
		get {
			DownloadManager.shared.sessionManager.tasks.filter { (task) -> Bool in
				task.status != .succeeded
			}
		}
	}
	
	lazy var deleteBtn: UIButton = {
		let btn = UIButton.init(type: .custom)
		btn.addTarget(self, action: #selector(deleteAll), for: UIControl.Event.touchUpInside)
		btn.backgroundColor = R.color.mainRed()!
		btn.setTitle("删除全部".localized, for: .normal)
		btn.titleLabel?.font = p_bfont(fontsize0)
		btn.cornerRadius = 5
		btn.frame = CGRect(x: 0, y: 0, width: 60, height: 25)
		btn.isHidden = true
		return btn
	}()

	
}

extension DownloadListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if self.segment.selectedSegmentIndex == 0 {
			let dowload = self.episodeList[indexPath.row]
			let detailVC = EpisodeInfoViewController.init()
			detailVC.episode = dowload
			self.navigationController?.dw_presentAsStork(controller: detailVC, heigth: kScreenHeight * 0.6, delegate: self)
		}
	}
	
}

// MARK: - 已下载
extension DownloadListViewController {
	
	@objc func deleteAll(){
		let alertConfig = CleanyAlertConfig(
			title: "Tips",
			message: "删除所有已缓存单集？".localized
		)
		
		
		let alert = AlertViewController.init(config: alertConfig)
		
		
		alert.addAction(title: "删除".localized, style: .default) { (action) in
			
			self.episodeList.forEach({ (episode) in
				let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
				let mp3Path = documentURL.appendingPathComponent("mp3").appendingPathComponent(episode.download_filpath)
				do {
					try FileManager.default.removeItem(at: mp3Path)
				}catch{
				}
				DatabaseManager.deleteDownload(title: episode.title);
			})
			self.tableview.reloadData()
			self.deleteBtn.isHidden = true
		}
		alert.addAction(title: "取消".localized, style: .cancel)
		self.present(alert, animated: true, completion: nil)
	}
	
	
	func showDeleteAction(indexPath: IndexPath){
		let alertConfig = CleanyAlertConfig(
			title: "Tips",
			message: "删除已缓存单集？".localized
		)
		
		
		let alert = AlertViewController.init(config: alertConfig)
		
		alert.addAction(title: "删除".localized, style: .default) { (action) in
			let episode = self.episodeList[indexPath.row]
			let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
			let mp3Path = documentURL.appendingPathComponent("mp3").appendingPathComponent(episode.download_filpath)
			
			do {
				try FileManager.default.removeItem(at: mp3Path)
			}catch{
			}
			
			DatabaseManager.deleteDownload(title: episode.title);
			self.tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
			self.tableview.reloadData()
		}
		alert.addAction(title: "取消".localized, style: .cancel)
		self.present(alert, animated: true, completion: nil)
	}
	
	
}



extension DownloadListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.segment.selectedSegmentIndex == 0 {
			return self.episodeList.count
		}
		return self.downloadTasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! DownloadTableViewCell
		
		if self.segment.selectedSegmentIndex == 0 {
			let episode = self.episodeList[indexPath.row]
			cell.config(episode: episode)
			cell.deleteClosure = { [weak self] () -> Void in
				self?.showDeleteAction(indexPath: indexPath)
			}
            cell.downloadSuccess = { [weak self] in
                if let self = self {
                    self.tableview.reloadData()
                }
            }
			return cell
        }
		
		let task = self.downloadTasks[indexPath.row]
		cell.config(task: task)
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return self.segment.selectedSegmentIndex == 0
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			self.showDeleteAction(indexPath: indexPath)
		}
	}
	
	
	
}

extension DownloadListViewController : DZNEmptyDataSetSource {
	
	func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		return UIImage.init(named: "download-empty")
	}
	
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		return NSAttributedString.init(string: "您还没下载过哦~".localized, attributes: [NSAttributedString.Key.font: pfont(fontsize2)])
	}
	
}


