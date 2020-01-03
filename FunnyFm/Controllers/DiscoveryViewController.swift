//
//  DiscoveryViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/24.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import OfficeUIFabric

class DiscoveryViewController: BaseViewController {

	let rssAddView: RssAddView = RssAddView.init(frame: CGRect.zero)
	let vm: PodDetailViewModel = PodDetailViewModel()
	var searchBtn : UIButton = UIButton.init(type: .custom)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "发现"
		self.setupUI()
		self.dw_addConstraints()
		self.vm.delegate = self
		self.rssAddView.searchBlock = { [weak self] rss in
			MSHUD.shared.show(from: self!)
			self!.vm.getPrev(feedUrl: rss)
		}
    }

}

// actions
extension DiscoveryViewController {
	
    @objc func toSearch() {
		let search = SearchViewController.init()
		self.navigationController?.pushViewController(search);
	}
	
}

extension DiscoveryViewController: PodDetailViewModelDelegate {
	
	func podDetailParserSuccess() {
		MSHUD.shared.hide()
		let preview = PodPreviewViewController()
		preview.itunsPod = self.vm.pod
		self.present(preview, animated: true, completion: nil)
	}
	
	func podDetailCancelSubscribeSuccess() {
	}
	
	func viewModelDidGetDataSuccess() {
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
	}
}


extension DiscoveryViewController {
	
	func dw_addConstraints(){
		self.view.addSubview(self.rssAddView)
		self.view.addSubview(self.searchBtn)
		
		self.searchBtn.snp.makeConstraints { (make) in
		   make.size.equalTo(CGSize.init(width: 40, height: 40))
		   make.right.equalToSuperview().offset(-16)
		   make.centerY.equalTo(self.titleLB)
		}
		
		self.rssAddView.snp.makeConstraints { (make) in
			make.top.equalTo(self.topBgView.snp_bottom).offset(8.auto())
			make.centerX.equalToSuperview()
			make.width.equalToSuperview().offset(-24.auto())
			make.height.equalTo(40)
		}
	}
	
	func setupUI(){
		
        self.searchBtn.setBackgroundImage(UIImage.init(named: "search"), for: .normal)
        self.searchBtn.addTarget(self, action: #selector(toSearch), for:.touchUpInside)
		
	}
	
}
