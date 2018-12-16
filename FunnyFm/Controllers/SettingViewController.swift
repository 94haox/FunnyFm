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
            make.top.equalTo(self.view.snp.topMargin)
            make.left.equalToSuperview().offset(16)
        }
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.titleLB.snp.bottom)
        }
    }
    
    lazy var datasource : Array = {return []}()
	lazy var settings : Array = {return []}()
	lazy var feedbacks : Array = {return []}()
    
    func setUpDataSource (){
        
        self.settings.append(["title":"接收通知","imageName":"notify"])
        self.feedbacks.append(["title":"github issue","imageName":"github","rightImage":""])
        self.feedbacks.append(["title":"www.funnyfm@outlook.com","imageName":"mail"])
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
		table.sectionHeaderHeight = 30
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
}


extension SettingViewController {
	
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0{
			
			
			return
		}
		
		
		
    }
    
    
}

extension SettingViewController {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return self.settings.count
		}
		return self.feedbacks.count
	}
	
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView.init()
		let lb = UILabel.init(text: "通知")
		lb.backgroundColor = CommonColor.background.color
		lb.textColor = CommonColor.subtitle.color
		lb.font = pfont(fontsize2)
		if section == 1 {
			lb.text = "反馈"
		}
		view.addSubview(lb)
		lb.snp.makeConstraints { (make) in
			make.top.height.right.equalToSuperview()
			make.left.equalToSuperview().offset(17)
		}
		return view
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
		cell.backgroundColor = CommonColor.cellbackgroud.color
		if indexPath.section == 0 {
			let item = self.settings[indexPath.row] as! Dictionary<String,String>
			cell.config(dic: item)
		}else{
			let item = self.feedbacks[indexPath.row] as! Dictionary<String,String>
			cell.config(dic: item)
		}
		
		return cell
	}
}
