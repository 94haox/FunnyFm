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
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableview)
        self.view.addSubview(self.titleLB)
        
        self.titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin).offset(30)
            make.left.equalToSuperview().offset(16)
        }
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.titleLB.snp.bottom)
        }
    }
    
    
    lazy var titleLB: UILabel = {
        let lb = UILabel.init(text: "我的下载")
        lb.font = p_bfont(32)
        lb.textColor = CommonColor.subtitle.color
        return lb
    }()
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: "tablecell")
        table.separatorStyle = .none
        table.rowHeight = 131
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    
    lazy var episodeList : [Episode] = {
        return DatabaseManager.allDownload()
    }()
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension DownloadListController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let history = self.historyList[indexPath.row]
        //        FMToolBar.shared.configToolBar(history)
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
        cell.configCell(episode)
    }
    
}

