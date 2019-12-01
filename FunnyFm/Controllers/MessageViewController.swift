//
//  MessageViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {
	
	var vm: GeneralViewModel = GeneralViewModel()
	
	var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "服务消息".localized
		self.vm.delegate = self
		self.setupUI()
		self.vm.getAllMessageList()
    }
    
}


extension MessageViewController: UICollectionViewDelegate{
	
	
}

extension MessageViewController: ViewModelDelegate {
	
	func viewModelDidGetDataSuccess() {
		self.collectionView.reloadData()
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		
	}
}

extension MessageViewController: UICollectionViewDataSource{
	 
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.vm.messageList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		if cell is MessageCollectionViewCell {
			let msgCell = cell as! MessageCollectionViewCell
			let message = self.vm.messageList[indexPath.row]
			msgCell.config(msg: message)
			msgCell.moreClosure = { [weak self] () -> Void in
				let detailVC = MessageDetailViewController()
				detailVC.detailInfoTextView.text = message.content
				self?.navigationController?.pushViewController(detailVC)
			}
		}
		
		return cell
	}
	
}


extension MessageViewController {
	
	func setupUI(){
		let layout = UICollectionViewFlowLayout.init()
		layout.itemSize = CGSize.init(width: kScreenWidth*0.9, height: 140)
		layout.minimumLineSpacing = 30
		self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
		self.collectionView.register(UINib.init(nibName: "MessageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
		self.collectionView.contentInset = UIEdgeInsets.init(top: 30, left: 0, bottom: 100, right: 0)
		self.collectionView.showsVerticalScrollIndicator = false
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.backgroundColor = CommonColor.background.color
		
		self.view.addSubview(self.collectionView)
		self.collectionView.snp.makeConstraints { (make) in
			make.left.width.bottom.equalToSuperview()
			make.top.equalTo(self.topBgView.snp.bottom)
		}
	}
	
	
}


