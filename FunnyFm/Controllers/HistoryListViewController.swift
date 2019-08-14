//
//  HistoryListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class HistoryListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableview)
        self.view.addSubview(self.titleLB)
		
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
    
    
    lazy var titleLB: UILabel = {
        let lb = UILabel.init(text: "近期收听".localized)
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
		table.emptyDataSetSource = self
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    
    lazy var historyList : [Episode] = {
        return DatabaseManager.allHistory()
    }()

}


extension HistoryListViewController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = self.historyList[indexPath.row]
//        FMToolBar.shared.configToolBar(history)
//		FMToolBar.shared.toPlayDetailView()
    }
    
}

extension HistoryListViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeAlbumTableViewCell else { return }
        let history = self.historyList[indexPath.row]
        cell.configCell(history)
    }
    
}

extension HistoryListViewController : DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "download-empty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "您还未收听哦~".localized, attributes: [NSAttributedString.Key.font: pfont(fontsize2)])
    }
    
}
