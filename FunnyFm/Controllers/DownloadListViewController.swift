//
//  DownloadListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/12.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class DownloadListViewController: BaseViewController {
	
	var isDownloaded: Bool = false
	
	var sectionSegment: DWSegment = DWSegment()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.titleLB.text = "我的下载".localized
		self.view.addSubview(self.tableview)
		self.view.addSubview(self.sectionSegment)
		sectionSegment.config(titles: ["正在下载".localized,"已下载".localized])
		self.view.insertSubview(self.tableview, at: 0)
		sectionSegment.addTarget(self, action: #selector(changeSection), for: .valueChanged)
		self.tableview.reloadData()
		self.sectionSegment.snp.makeConstraints { (make) in
			make.top.equalTo(self.titleLB.snp.bottom).offset(10)
			make.size.equalTo(CGSize.init(width: 200, height: 40))
			make.centerX.equalToSuperview()
		}
		self.tableview.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.bottom.equalToSuperview()
			make.top.equalTo(self.topBgView.snp.bottom)
		}
		DownloadManager.shared.delegate = self
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.deleteBtn.isHidden = self.episodeList.count < 1
	}
	
	@objc func changeSection(){
		self.isDownloaded = !self.isDownloaded
		self.tableview.reloadData()
	}
	
	lazy var tableview : UITableView = {
		let table = UITableView.init(frame: CGRect.zero, style: .plain)
		let nib = UINib(nibName: String(describing: DownloadTableViewCell.self), bundle: nil)
		table.register(nib, forCellReuseIdentifier: "tablecell")
		table.separatorColor = CommonColor.cellbackgroud.color
		table.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
		table.contentInset = UIEdgeInsets.init(top: 50, left: 0, bottom: 0, right: 0)
		table.rowHeight = 85
		table.delegate = self
		table.dataSource = self
		table.emptyDataSetSource = self
		table.showsVerticalScrollIndicator = false
		table.tableFooterView = UIView()
		table.backgroundColor = .white
		return table
	}()
	
	var episodeList : [Episode] = DatabaseManager.allDownload()
	
	lazy var deleteBtn: UIButton = {
		let btn = UIButton.init(type: UIButton.ButtonType.custom)
		btn.addTarget(self, action: #selector(deleteAll), for: UIControl.Event.touchUpInside)
		btn.backgroundColor = CommonColor.mainRed.color
		btn.setTitle("删除全部".localized, for: UIControl.State.normal)
		btn.titleLabel?.font = p_bfont(fontsize6)
		btn.cornerRadius = 15
		btn.addShadow(ofColor: CommonColor.mainPink.color, radius: 5, offset: CGSize.init(width: 2, height: 5), opacity: 0.5)
		return btn
	}()

	
}



extension DownloadListViewController: DownloadManagerDelegate {
	
	func didDownloadCancel(sourceUrl: String) {
		self.tableview.reloadData()
	}
	
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String) {
		self.episodeList = DatabaseManager.allDownload()
		self.tableview.reloadData()
	}
	
}


extension DownloadListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if isDownloaded {
			let dowload = self.episodeList[indexPath.row]
			FMToolBar.shared.configToolBar(dowload)
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
			
			self.episodeList.removeAll()
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
			self.episodeList = DatabaseManager.allDownload()
			self.tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
		}
		alert.addAction(title: "取消".localized, style: .cancel)
		self.present(alert, animated: true, completion: nil)
	}
	
	
}



extension DownloadListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isDownloaded {
			return self.episodeList.count
		}
		return DownloadManager.shared.downloadQueue.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! DownloadTableViewCell
		
		if isDownloaded {
			let episode = self.episodeList[indexPath.row]
			cell.config(episode: episode)
			cell.deleteClosure = { [weak self] () -> Void in
				self?.showDeleteAction(indexPath: indexPath)
			}
			return cell
		}
		
		
		let taskList = DownloadManager.shared.downloadQueue
		let task = taskList[indexPath.row]
		cell.config(task: task)
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return isDownloaded
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

extension DownloadListViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if scrollView.contentOffset.y > 0 {
			self.topBgView.addShadow(ofColor: CommonColor.subtitle.color, radius: 10, offset: CGSize.init(width: 0, height: 10), opacity: 0.8)
		}else{
			self.topBgView.addShadow(ofColor: .clear, radius: 10, offset: CGSize.init(width: 0, height: 10), opacity: 0.8)
		}
	}
}

