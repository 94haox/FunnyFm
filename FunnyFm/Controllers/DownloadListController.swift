//
//  DownloadListController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class DownloadListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text =  "我的下载".localized
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableview)
		self.view.insertSubview(self.tableview, at: 0)
		self.view.addSubview(self.deleteBtn)
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.topBgView.snp.bottom)
        }
		
		self.deleteBtn.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp.bottomMargin).offset(-15)
			make.size.equalTo(CGSize.init(width: 180, height: 50))
			make.centerX.equalToSuperview()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.deleteBtn.isHidden = self.episodeList.count < 1
	}
	
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
		table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 65, right: 0);
        return table
    }()
    
    
    lazy var episodeList : [Episode] = {
        return DatabaseManager.allDownload()
    }()
	
	lazy var deleteBtn: UIButton = {
		let btn = UIButton.init(type: UIButton.ButtonType.custom)
		btn.addTarget(self, action: #selector(deleteAll), for: UIControl.Event.touchUpInside)
		btn.backgroundColor = CommonColor.mainRed.color
		btn.setTitle("删除全部", for: UIControl.State.normal)
		btn.titleLabel?.font = p_bfont(fontsize6)
		btn.cornerRadius = 15
		btn.addShadow(ofColor: CommonColor.mainPink.color, radius: 5, offset: CGSize.init(width: 2, height: 5), opacity: 0.5)
		return btn
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
        cell.configNoDetailCell(episode)
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

extension DownloadListController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if scrollView.contentOffset.y > 0 {
			self.topBgView.addShadow(ofColor: CommonColor.subtitle.color, radius: 10, offset: CGSize.init(width: 0, height: 10), opacity: 0.8)
		}else{
			self.topBgView.addShadow(ofColor: .clear, radius: 10, offset: CGSize.init(width: 0, height: 10), opacity: 0.8)
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



