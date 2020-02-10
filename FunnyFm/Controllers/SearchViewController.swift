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
		
	@IBAction func toTopicVC(_ sender: Any) {
		let topicVC = TopicViewController.init()
		self.navigationController?.pushViewController(topicVC)
	}
	
}


extension SearchViewController : PodListViewModelDelegate {
	func didSyncSuccess(index: Int) {

	}
	
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
		if pod.feedUrl.length() < 1 {
			SwiftNotice.showText("Error - Rss not found")
			return;
		}
        let podcast = DatabaseManager.getPodcast(feedUrl: pod.feedUrl)
        if podcast.isSome {
            let podvc = PodDetailViewController.init(pod: podcast!)
            self.navigationController?.pushViewController(podvc)
            return
        }
		let preview = PodPreviewViewController()
		preview.itunsPod = pod
		self.present(preview, animated: true, completion: nil)
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
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
		self.vm.searchPod(keyword: textField.text!)
		MSHUD.shared.show(in: self.view)
		return true
	}
	
}

extension SearchViewController: DZNEmptyDataSetSource{
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		return NSAttributedString.init(string: "你喜欢什么播客呢？", attributes: [NSAttributedString.Key.font : pfont(12)])
	}
	
	func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		return UIImage.init(named: "empty")
	}
}



extension SearchViewController {
	func dw_addSubviews(){
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
		self.tableview.emptyDataSetSource = self
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)

		self.searchTF.attributedPlaceholder = FunnyFm.attributePlaceholder("搜索播客".localized)
		self.searchTF.font = p_bfont(14)
		self.searchTF.textColor = CommonColor.title.color
		
		self.view.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.left.bottom.width.equalTo(self.view);
			make.top.equalTo(self.searchTF.snp.bottom).offset(12);
		}
		
	}
}
