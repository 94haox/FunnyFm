//
//  PodDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/7/10.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class PodDetailViewController: BaseViewController {
	
	var topView: UIView!
	
	var podImageView: UIImageView!
	
	var podNameLB: UILabel!
	
	var podAuthorLB: UILabel!
	
	var countLB: UILabel!
	
	var pod: iTunsPod!
	
	var subBtn: UIButton!
	
	var tableview : UITableView!
	
	var vm: PodDetailViewModel!
	
	init(pod: iTunsPod) {
		super.init(nibName: nil, bundle: nil)
		self.pod = pod
		self.vm = PodDetailViewModel()
		self.vm.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.addSubviews()
		self.dw_addConstraints()
        self.vm.parserNewChapter(pod: self.pod)
		self.config()
    }

	func config(){
		self.title = "detail"
		self.podNameLB.text = self.pod.trackName
		self.podAuthorLB.text = self.pod.podAuthor
		self.podImageView.kf.setImage(with: URL.init(string: self.pod.artworkUrl600)!) {result in}
	}

}

extension PodDetailViewController: PodDetailViewModelDelegate{
	
	func viewModelDidGetDataSuccess() {}
	
	func viewModelDidGetDataFailture(msg: String?) {}
		
	func podDetailParserSuccess() {
		DispatchQueue.main.async {
			self.countLB.text = String(self.vm.episodeList.count) + "  Episodes"
			self.tableview.reloadData()
		}
	}
	
	func podDetailCancelSubscribeSuccess() {
	
	}
}


extension PodDetailViewController: UITableViewDelegate {
	
}

extension PodDetailViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.vm.episodeList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? HomeAlbumTableViewCell else { return }
		let episode = self.vm.episodeList[indexPath.row]
		cell.configCell(episode)
	}
}


extension PodDetailViewController {
	
	func dw_addConstraints(){
		self.view.addSubview(self.tableview)
		self.view.addSubview(self.topView)
		self.topView.addSubview(self.podImageView)
		self.topView.addSubview(self.podNameLB)
		self.topView.addSubview(self.podAuthorLB)
		self.topView.addSubview(self.countLB)
		self.topView.addSubview(self.subBtn)
		
		self.topView.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.top.equalTo(self.view.snp.topMargin)
			make.height.equalTo(150)
		}
		
		self.podImageView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(30)
			make.top.equalToSuperview().offset(18)
			make.size.equalTo(CGSize.init(width: 55, height: 55))
		}
		
		self.podNameLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.podImageView.snp.right).offset(12)
			make.right.equalToSuperview().offset(30)
			make.top.equalTo(self.podImageView)
		}
		
		self.podAuthorLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.podNameLB);
			make.top.equalTo(self.podNameLB.snp.bottom).offset(16)
		}
		
		self.countLB.snp.makeConstraints { (make) in
			make.left.equalTo(self.podAuthorLB.snp.right).offset(8);
			make.top.equalTo(self.podAuthorLB)
		}
		
		self.subBtn.snp.makeConstraints { (make) in
			make.left.equalTo(self.podImageView);
			make.right.equalToSuperview().offset(-30)
			make.height.equalTo(40)
			make.top.equalTo(self.podImageView.snp.bottom).offset(25)
		}
		
		
		self.tableview.snp.makeConstraints { (make) in
			make.left.width.bottom.equalToSuperview();
			make.top.equalTo(self.topView.snp.bottom)
		}
		
	}
	
	func addSubviews(){
		self.topView = UIView.init()
		self.topView.backgroundColor = .white
		self.topView.cornerRadius = 15;
		
		self.podImageView = UIImageView.init()
		self.podImageView.cornerRadius = 5;
		
		self.podNameLB = UILabel.init(text: self.pod.trackName)
		self.podNameLB.textColor = CommonColor.title.color
		self.podNameLB.font = p_bfont(18)
		
		self.podAuthorLB = UILabel.init(text: self.pod.podAuthor)
		self.podAuthorLB.textColor = CommonColor.content.color
		self.podAuthorLB.font = p_bfont(15)
		
		self.countLB = UILabel.init(text: self.pod.releaseDate)
		self.countLB.textColor = CommonColor.content.color
		self.countLB.font = p_bfont(12)
		
		self.subBtn = UIButton.init(type: .custom)
		self.subBtn.setTitle("已订阅", for: .normal)
		self.subBtn.setTitleColor(.white, for: .normal)
		self.subBtn.setTitle("订阅", for: .selected)
		self.subBtn.setTitleColor(CommonColor.mainRed.color, for: .selected)
		self.subBtn.backgroundColor = CommonColor.mainRed.color
		self.subBtn.titleLabel?.font = p_bfont(12)
		self.subBtn.borderWidth = 1;
		self.subBtn.borderColor = CommonColor.mainRed.color
		self.subBtn.cornerRadius = 5
		
		self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
		let cellnib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
		self.tableview.sectionHeaderHeight = 36
		self.tableview.register(cellnib, forCellReuseIdentifier: "tablecell")
		self.tableview.backgroundColor = CommonColor.background.color
		self.tableview.separatorStyle = .none
		self.tableview.rowHeight = 100
		self.tableview.delegate = self
		self.tableview.dataSource = self
		self.tableview.showsVerticalScrollIndicator = false
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
		
	}
	
}
