//
//  TopicViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/13.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import JXSegmentedView



class TopicViewController: BaseViewController {

	var segmentedView: JXSegmentedView!
	var segmentedDataSource: JXSegmentedTitleDataSource!
	var tableview: UITableView!
	var changeBtn: UIButton = {
		let button = UIButton(type: .custom)
		button.tintColor = R.color.mainRed()
		button.setImage(UIImage(systemName: "arrow.right.arrow.left.circle"), for: .normal)
		return button
	}()
	
	let vm : PodListViewModel = {
		return PodListViewModel.init()
	}()
	
	var country = CountryCodeLibrary.shared.deviceCountry

   	override func viewDidLoad() {
		super.viewDidLoad()
		self.dw_addSubviews()
		self.title = "播客分类".localized
		self.vm.delegate = self
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.changeBtn)
		self.changeBtn.addTarget(self, action: #selector(changeCountry), for: .touchUpInside)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.vm.searchTopic(keyword: self.vm.topicIDs[0], regionCode: country.isoRegionCode)
		Hud.shared.show(on: self.view)
        
	}
	
	@objc func changeCountry() {
		let countryVC = SelectCountryViewController()
		countryVC.delegate = self
		self.navigationController?.pushViewController(countryVC)
	}
}


extension TopicViewController : PodListViewModelDelegate {
	func didSyncSuccess(index: Int) {

	}
	
	func viewModelDidGetDataSuccess() {
		Hud.shared.hide()
		self.tableview.reloadData()
		DispatchQueue.main.asyncAfter(deadline: .init(uptimeNanoseconds: UInt64(0.2))) {
			self.tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
		}
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		Hud.shared.hide()
		SwiftNotice.showText(msg!)
		self.tableview.reloadData();
	}
}

extension TopicViewController : UITableViewDelegate, UITableViewDataSource {
	
	
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

extension TopicViewController: JXSegmentedViewDelegate {
	
	func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
		self.vm.searchTopic(keyword: self.vm.topicIDs[index], regionCode: country.isoRegionCode)
		Hud.shared.show(on: self.view)
	}
	
}

extension TopicViewController: SelectCountryViewControllerDelegate {
	
	func selectCountryViewController(_ viewController: SelectCountryViewController, didSelectCountry country: Country) {
		self.country = country
		viewController.navigationController?.popViewController()
	}
	
}

extension TopicViewController {
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
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: toolbarH*2, right: 0)
		
		segmentedView = JXSegmentedView()
		segmentedView.delegate = self
		segmentedDataSource = JXSegmentedTitleDataSource()
		segmentedDataSource.titleSelectedColor = R.color.mainRed()!
		segmentedDataSource.titleNormalColor = CommonColor.content.color
		segmentedDataSource.isTitleColorGradientEnabled = true
		segmentedDataSource.titles = self.vm.topics
		segmentedView.dataSource = self.segmentedDataSource
		let indicator = JXSegmentedIndicatorLineView()
		indicator.indicatorColor = R.color.mainRed()!
		segmentedView.indicators = [indicator]
		view.addSubview(self.segmentedView)
		
		self.view.addSubview(self.segmentedView)
		self.view.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.left.bottom.width.equalTo(self.view);
			make.top.equalTo(self.segmentedView.snp.bottom).offset(12);
		}
		
		self.segmentedView.snp.makeConstraints { (make) in
			make.left.width.equalTo(self.view);
			make.top.equalTo(self.view);
			make.height.equalTo(40)
		}
		
	}
}

