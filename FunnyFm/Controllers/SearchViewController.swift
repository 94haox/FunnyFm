//
//  SearchViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/14.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import OfficeUIFabric
import SPStorkController
import Lottie

class SearchViewController: UIViewController {

	@IBOutlet weak var searchTF: UITextField!
	
	var tableview : UITableView!
	
	let vm : PodListViewModel = {
		return PodListViewModel.init()
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.dw_addSubviews()
		self.searchTF.delegate = self;
		self.vm.delegate = self;
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	func dw_addSubviews(){
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		let cellnib = UINib(nibName: String(describing: ItunsPodTableViewCell.self), bundle: nil)
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
		self.tableview.backgroundColor = .clear;
		self.tableview.separatorStyle = .none
		self.tableview.rowHeight = 100
		self.tableview.delegate = self
		self.tableview.dataSource = self
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.keyboardDismissMode = .onDrag
		self.view.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.left.bottom.width.equalTo(self.view);
			make.top.equalTo(self.searchTF.snp.bottom).offset(16);
		}
		self.searchTF.attributedPlaceholder = FunnyFm.attributePlaceholder("搜索播客")
		self.searchTF.font = p_bfont(14)
		self.searchTF.textColor = CommonColor.title.color
	}

}


extension SearchViewController : ViewModelDelegate {
	func viewModelDidGetDataSuccess() {
		MSHUD.shared.hide()
		self.tableview.reloadData()
		DispatchQueue.main.asyncAfter(deadline: .init(uptimeNanoseconds: UInt64(0.2))) {
			self.tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
		}
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		MSHUD.shared.hide()
		SwiftNotice.showText(msg!)
		self.tableview.reloadData();
	}
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let pod = self.vm.itunsPodlist[indexPath.row]
		let preview = PodPreviewViewController()
		preview.modalPresentationStyle = .overCurrentContext
		let transitionDelegate = SPStorkTransitioningDelegate()
		transitionDelegate.customHeight = 350;
		preview.transitioningDelegate = transitionDelegate
		preview.modalPresentationStyle = .custom
		preview.modalPresentationCapturesStatusBarAppearance = true
		self.present(preview, animated: true, completion: nil)
		preview.configWithPod(pod: pod)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.vm.itunsPodlist.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? ItunsPodTableViewCell else { return }
		let pod = self.vm.itunsPodlist[indexPath.row]
		cell.config(pod)
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
		self.vm.searchPod(keyword: textField.text!)
		MSHUD.shared.show(in: self.view)
		return true
	}
	
}
