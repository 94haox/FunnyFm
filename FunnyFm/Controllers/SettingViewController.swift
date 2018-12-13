//
//  SettingViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.tableView.backgroundColor = CommonColor.background.color
        self.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.setUpDataSource()
    }
    
    lazy var datasource : Array = {return []}()
    
    func setUpDataSource (){
        self.datasource.append(["title":"接收通知","imageName":"notify"])
        self.datasource.append(["title":"github issue","imageName":"notify"])
        self.datasource.append(["title":"www.funnyfm@outlook.com","imageName":"mail"])
    }
    
}


extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
        cell.backgroundColor = CommonColor.cellbackgroud.color
        let item = self.datasource[indexPath.row] as! Dictionary<String,String>
//        cell.configCell(item)
        cell.config(dic: item)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
