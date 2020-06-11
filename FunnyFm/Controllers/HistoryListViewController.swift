//
//  HistoryListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class HistoryListViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "近期收听".localized
        self.view.addSubview(self.tableview)
		self.tableview.reloadData()
		self.view.insertSubview(self.tableview, at: 0)
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: HistoryTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: "tablecell")
        table.separatorStyle = .none
        table.rowHeight = 85
        table.delegate = self
        table.dataSource = self
		table.emptyDataSetSource = self
        table.showsVerticalScrollIndicator = false
		table.backgroundColor = CommonColor.white.color
		table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: toolbarH*2, right: 0)
        return table
    }()
	
    lazy var historyList : [Episode] = {
        return DatabaseManager.allHistory().reversed()
    }()

}


// MARK: - UITableViewDelegate
extension HistoryListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = self.historyList[indexPath.row]
        FMToolBar.shared.configToolBar(history)
		self.navigationController?.popViewController()
//		 FMToolBar.shared.toPlayDetailView()
    }
    
}

// MARK: - UITableViewDataSource
extension HistoryListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HistoryTableViewCell else { return }
        let history = self.historyList[indexPath.row]
        cell.config(episode: history)
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
