//
//  DownloadListController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import CleanyModal

class DownloadListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableview)
        self.view.addSubview(self.titleLB)
//        tableview.setEditing(true, animated: true)
        self.titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.left.equalToSuperview().offset(16)
        }
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.titleLB.snp.bottom)
        }
    }
	
	
	func showDeleteAction(indexPath: IndexPath){
		let alertConfig = CleanyAlertConfig(
			title: "Tips",
			message: "删除已缓存单集？".localized
		)
		
		
		let alert = AlertViewController.init(config: alertConfig)
		
		alert.addAction(title: "删除".localized, style: .default) { (action) in
			let episode = self.episodeList[indexPath.row]
			DatabaseManager.deleteDownload(chapterId: episode.collectionId);
			self.episodeList = DatabaseManager.allDownload()
			self.tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
		}
		alert.addAction(title: "取消".localized, style: .cancel)
		self.present(alert, animated: true, completion: nil)
	}
    
    lazy var titleLB: UILabel = {
        let lb = UILabel.init(text: "我的下载".localized)
        lb.font = p_bfont(titleFontSize)
        lb.textColor = CommonColor.subtitle.color
        return lb
    }()
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: "tablecell")
        table.separatorStyle = .none
        table.rowHeight = 100
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.emptyDataSetSource = self
        return table
    }()
    
    
    lazy var episodeList : [Episode] = {
        return DatabaseManager.allDownload()
    }()
    
}


extension DownloadListController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let history = self.episodeList[indexPath.row]
		FMToolBar.shared.configToolBar(history)
    }
    
}

extension DownloadListController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeAlbumTableViewCell else { return }
        let episode = self.episodeList[indexPath.row]
        cell.configDownloadCell(episode)
    }
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
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

extension DownloadListController : DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "download-empty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "您还没下载过哦~".localized, attributes: [NSAttributedString.Key.font: pfont(fontsize2)])
    }
    
}



