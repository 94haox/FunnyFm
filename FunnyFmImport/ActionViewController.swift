//
//  ActionViewController.swift
//  FunnyFmImport
//
//  Created by 吴涛 on 2020/6/12.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import MobileCoreServices
import SnapKit
import AutoInch

class ActionViewController: UIViewController {

	
	let tableview = UITableView.init(frame: CGRect.zero, style: .insetGrouped)

	var items: [OPMLItem]?


    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.handleInputItem()
	}
	
	private func handleInputItem() {
		print("\(self.extensionContext!.inputItems)")
		
		ExtensionItemHandler.handleInputItem(items: self.extensionContext!.inputItems, firstResponder: self) { (isSupport) in
			if !isSupport {
				self.alert("错误", message: "不支持的导入类型") { [weak self] action in
					self?.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
				}
			}else{
				self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
			}
		}
	}
	


	@IBAction func next(_ sender: Any) {
		self.alert("将在下次打开 FunnyFm 时完成操作") { [weak self] action in
			self?.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
		}
	}

}

extension ActionViewController: UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let items = self.items else {
			return 0
		}
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OpmlTableViewCell
		let item = self.items![indexPath.row]
		cell.config(forImpot: item)
		return cell
	}
	
	
}


extension ActionViewController {
	
	func setupUI() {
		tableview.register(UINib.init(nibName: "OpmlTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
		tableview.separatorStyle = .none
		tableview.rowHeight = 60.auto()
		tableview.dataSource = self;
		view.addSubview(tableview)
		tableview.snp.makeConstraints { (make) in
			make.top.equalTo(44.auto())
			make.left.width.bottom.equalToSuperview()
		}
	}
	
	
}
