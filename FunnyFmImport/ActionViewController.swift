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

	@IBOutlet weak var contentTextView: UITextView!
	
	let tableview = UITableView.init(frame: CGRect.zero, style: .insetGrouped)

	var items: [OPMLItem]?


    override func viewDidLoad() {
        super.viewDidLoad()
//        Hud.shared.show()
		self.setupUI()
		self.handleInputItem()
    }
	
	private func handleInputItem() {
		for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeXML as String) {
                    // This is an image. We'll load it, then place it in our image view.
                    provider.loadItem(forTypeIdentifier: kUTTypeXML as String, options: nil, completionHandler: { (xmlUrl, error) in
						guard let url = xmlUrl as? URL else {
//							showAutoHiddenHud(style: .error, text: "暂时只支持 OPML 导入")
							return
						}
						DispatchQueue.global().async {
							self.parserOPML(url: url)
						}
                    })
					break
                }
            }
        }
	}
	
	private func parserOPML(url: URL) {
		let opmlData = try? Data(contentsOf: url)
		guard let data = opmlData, let opmlString = String.init(data: data, encoding: .utf8) else {
			DispatchQueue.main.async {
//				showAutoHiddenHud(style: .error, text: "OPML 内容格式错误")
//				Hud.shared.hide()
			}
			return
		}
		let parser = Parser(text: opmlString)
		let _ = parser.success { (items) in
			self.items = items
			DispatchQueue.main.async {
				self.tableview.reloadData()
			}
		}
		
		let _ = parser.failure { (error) in
			DispatchQueue.global().async {
//				showAutoHiddenHud(style: .error, text: "OPML 内容解析错误")
			}
			print(error)
		}
		parser.main()
	}

	@IBAction func next(_ sender: Any) {
		self.extensionContext?.open(URL(string: "funnyfm://podcast")!, completionHandler: { [weak self] (result) in
			self?.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
		})
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
			make.top.equalToSuperview().offset(64)
			make.left.width.bottom.equalToSuperview()
		}
	}
	
	
}
