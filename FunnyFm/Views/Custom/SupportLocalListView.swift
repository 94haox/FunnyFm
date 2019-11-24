//
//  SupportLocalListView.swift
//  ComponentList
//
//  Created by Duke on 2019/11/21.
//  Copyright © 2019 duke. All rights reserved.
//

import UIKit

class SupportLocalListView: UIView {

   	var changeLocalClosure: ((String, String) -> Void)!

	var locals: NSDictionary = {
		let path = Bundle.main.path(forResource: "SuportLocalList", ofType: "plist")!
		let dic = NSDictionary.init(contentsOfFile: path)!
		return dic
	}()
	
	var tableView: UITableView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension SupportLocalListView: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let title = self.locals.allKeys[indexPath.row] as! String
		let local = self.locals[title] as! String
		self.changeLocalClosure!(title,local)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.locals.allKeys.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let string = self.locals.allKeys[indexPath.row] as! String
		cell.textLabel?.text = string
		cell.textLabel?.textAlignment = .center
		return cell
	}
}


extension SupportLocalListView {
	func setupUI(){
		
		self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.separatorStyle = .none
		self.tableView.contentInset = UIEdgeInsets.init(top: 44, left: 0, bottom: 0, right: 0)
		self.addSubview(self.tableView)
		
		self.tableView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
	}
}
