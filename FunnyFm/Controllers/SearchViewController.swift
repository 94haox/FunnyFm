//
//  SearchViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/14.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import OfficeUIFabric
import Lottie


class SearchViewController: UIViewController {

	@IBOutlet weak var searchTF: UITextField!
	var isCategory = true
	@IBOutlet weak var cateBtn: UIButton!
	
	
	var tableview : UITableView!
	
	let vm : PodListViewModel = {
		return PodListViewModel.init()
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.dw_addSubviews()
		self.searchTF.delegate = self;
		self.vm.delegate = self
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	@IBAction func inCategoryAction(_ sender: Any) {
		isCategory = true
		self.cateBtn.isHidden = isCategory
		self.vm.itunsPodlist.removeAll()
		self.tableview.reloadData()
	}
	
	func dw_addSubviews(){
		self.cateBtn.setImage(UIImage(named: "grid")?.maskWithColor(color: CommonColor.subtitle.color), for: .normal)
		self.cateBtn.isHidden = true
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		let cellnib = UINib(nibName: String(describing: ItunsPodTableViewCell.self), bundle: nil)
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
		self.tableview.register(TopicTableViewCell.self, forCellReuseIdentifier: "celld")
		self.tableview.backgroundColor = .clear;
		self.tableview.separatorStyle = .none
		self.tableview.delegate = self
		self.tableview.dataSource = self
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.keyboardDismissMode = .onDrag
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
		self.view.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.left.bottom.width.equalTo(self.view);
			make.top.equalTo(self.searchTF.snp.bottom).offset(16);
		}
		self.searchTF.attributedPlaceholder = FunnyFm.attributePlaceholder("搜索播客".localized)
		self.searchTF.font = p_bfont(14)
		self.searchTF.textColor = CommonColor.title.color
	}

}


extension SearchViewController : PodListViewModelDelegate {
	func didSyncSuccess(index: Int) {

	}
	
	func viewModelDidGetDataSuccess() {
		MSHUD.shared.hide()
		self.cateBtn.isHidden = false
		self.tableview.reloadData()
		DispatchQueue.main.asyncAfter(deadline: .init(uptimeNanoseconds: UInt64(0.2))) {
			self.tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
		}
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		MSHUD.shared.hide()
		self.cateBtn.isHidden = false
		SwiftNotice.showText(msg!)
		self.tableview.reloadData();
	}
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if isCategory {
			MSHUD.shared.show(from: self)
			self.vm.searchTopic(keyword: self.vm.topicIDs[indexPath.row])
			isCategory = false
			tableview.reloadData()
			return;
		}
		let pod = self.vm.itunsPodlist[indexPath.row]
		if pod.feedUrl.length() < 1 {
			SwiftNotice.showText("Error - Rss not found")
			return;
		}
		let preview = PodPreviewViewController()
		preview.configWithPod(pod: pod)
		self.dw_presentAsStork(controller: preview, heigth: 300, delegate: self)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isCategory {
			return self.vm.topics.count
		}
		return self.vm.itunsPodlist.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if isCategory {
			let cell = tableView.dequeueReusableCell(withIdentifier: "celld", for: indexPath) as! TopicTableViewCell
			cell.trackNameLabel.text = self.vm.topics[indexPath.row]
			cell.iconImageView.image = UIImage(named: self.vm.topicIcons[indexPath.row])?.maskWithColor(color: CommonColor.subtitle.color)
//			cell.iconImageView.layer.masksToBounds = true
			
			cell.backgroundColor = .white
			let bgColorView = UIView()
			bgColorView.backgroundColor = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
			cell.selectedBackgroundView = bgColorView
			return cell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? ItunsPodTableViewCell else { return }
		let pod = self.vm.itunsPodlist[indexPath.row]
		cell.config(pod)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if isCategory {
			return UITableView.automaticDimension
		}
		return 100
	}
}

extension SearchViewController : UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		UIView.animate(withDuration: 0.3) {
			self.searchTF.backgroundColor = .white;
			self.searchTF.addShadow(ofColor: UIColor.init(hex: "#d6d80e", alpha: 0.3), radius: 5, offset: CGSize.init(width: 0, height: 5), opacity: 0.6)
		}
		self.tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		UIView.animate(withDuration: 0.3) {
			self.searchTF.backgroundColor = UIColor.init(hex: "E2E3E9", alpha: 1);
			self.searchTF.addShadow(ofColor: UIColor.init(hex: "#d6d80e", alpha: 0.3), radius: 0, offset: CGSize.init(width: 0, height: 0), opacity: 0.6)
		}
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		if textField.text.isNone {
			return true;
		}
		
		if textField.text!.length() < 1 {
			return true
		}
		isCategory = false
		self.vm.searchPod(keyword: textField.text!)
		MSHUD.shared.show(in: self.view)
		return true
	}
	
}
