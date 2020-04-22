//
//  SearchViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/6/14.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Lottie


class SearchViewController: UIViewController {

	@IBOutlet weak var searchTF: UITextField!
	var tableview : UITableView!
	
	let vm = SearchViewModel()
	
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

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.vm.seachHistories.count > 0, indexPath.section == 0 {
            let keyword = self.vm.seachHistories[indexPath.row]
            self.searchTF.text = keyword
            self.vm.searchPod(keyword: keyword)
            Hud.shared.show(on: self.view)
            return
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.vm.seachHistories.count > 0 {
            return 2
        }
        return 1
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.vm.seachHistories.count > 0, section == 0 {
            return self.vm.seachHistories.count
        }
		return self.vm.itunsPodlist.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.vm.seachHistories.count > 0, indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
            let searhCell = cell as? SearchHistoryTableViewCell
            searhCell?.removeBlock = { [weak self] in
                self?.vm.removeHistory(index: indexPath.row)
                if let count = self?.vm.seachHistories.count, count > 0 {
                    tableView.reloadSection(0, with: .automatic)
                }else{
                    tableView.reloadData()
                }
            }
            return cell
        }
        
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.vm.seachHistories.count > 0, indexPath.section == 0 {
            let historiesCell = cell as? SearchHistoryTableViewCell
            historiesCell?.render(string: self.vm.seachHistories[indexPath.row])
            return
        }
		guard let cell = cell as? ItunsPodTableViewCell else { return }
		let pod = self.vm.itunsPodlist[indexPath.row]
		cell.config(pod)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.vm.seachHistories.count > 0, indexPath.section == 0 {
            return 30
        }
		return 100
	}
}

extension SearchViewController : UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		self.tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
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
		Hud.shared.show(on: self.view)
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
        self.view.backgroundColor = CommonColor.white.color
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		let cellnib = UINib(nibName: String(describing: ItunsPodTableViewCell.self), bundle: nil)
        let searchCellnib = UINib(nibName: String(describing: SearchHistoryTableViewCell.self), bundle: nil)
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
        self.tableview.register(searchCellnib, forCellReuseIdentifier: "historyCell")
		self.tableview.register(TopicTableViewCell.self, forCellReuseIdentifier: "celld")
		self.tableview.backgroundColor = CommonColor.white.color;
		self.tableview.separatorStyle = .none
		self.tableview.delegate = self
		self.tableview.dataSource = self
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.keyboardDismissMode = .onDrag
		self.tableview.emptyDataSetSource = self
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: toolbarH*2, right: 0)

		self.searchTF.attributedPlaceholder = FunnyFm.attributePlaceholder("搜索播客".localized)
		self.searchTF.font = pfont(14)
		self.searchTF.textColor = CommonColor.title.color
        let imageView = UIImageView.init(image: UIImage.init(systemName: "magnifyingglass.circle.fill"))
        self.searchTF.leftView = imageView
        self.searchTF.leftViewMode = .always
        self.searchTF.clearButtonMode = .whileEditing
        
		self.view.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.left.bottom.width.equalTo(self.view);
			make.top.equalTo(self.searchTF.snp.bottom).offset(12);
		}
		
	}
}
