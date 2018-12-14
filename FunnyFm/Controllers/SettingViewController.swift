//
//  SettingViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.view.backgroundColor = CommonColor.background.color
        self.tableview.backgroundColor = CommonColor.background.color
        self.setUpDataSource()
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
    
    lazy var datasource : Array = {return []}()
    
    func setUpDataSource (){
        
        self.datasource.append(["title":"接收通知","imageName":"notify"])
        self.datasource.append(["title":"github issue","imageName":"github","rightImage":""])
        self.datasource.append(["title":"www.funnyfm@outlook.com","imageName":"mail"])
    }
    
    lazy var titleLB: UILabel = {
        let lb = UILabel.init(text: "设置")
        lb.font = p_bfont(32)
        lb.textColor = CommonColor.subtitle.color
        return lb
    }()
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: SettingTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        table.rowHeight = 50
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
}


extension SettingViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
        cell.backgroundColor = CommonColor.cellbackgroud.color
        let item = self.datasource[indexPath.row] as! Dictionary<String,String>
//        cell.configCell(item)
        cell.config(dic: item)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
