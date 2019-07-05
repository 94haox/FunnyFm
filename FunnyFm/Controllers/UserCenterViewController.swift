//
//  UserCenterViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit


class UserCenterViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {

	var logoutBtn: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dw_addSubviews()
    }
	
	@objc func toLogoutAction(){
		UserCenter.shared.isLogin = false
		HorizonHUD.showSuccess("退出成功")
		self.navigationController?.popViewController()
	}
    
    func dw_addSubviews(){
        
        self.view.addSubview(self.titleLB)
        self.view.addSubview(self.collectionView)
        self.titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin).offset(30)
            make.left.equalToSuperview().offset(30)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLB.snp.bottom).offset(50)
            make.left.width.bottom.equalToSuperview()
        }
		
		self.logoutBtn = UIButton.init(type: .custom)
		logoutBtn.setTitle("退出登录", for: .normal)
		logoutBtn.setTitleColor(.white, for: .normal)
		logoutBtn.backgroundColor = CommonColor.mainRed.color
		logoutBtn.cornerRadius = 5.0
		logoutBtn.titleLabel?.font = p_bfont(14);
		logoutBtn.addTarget(self, action: #selector(toLogoutAction), for: .touchUpInside)
		self.view.addSubview(self.logoutBtn)
		self.logoutBtn.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-40)
			make.width.equalToSuperview().offset(-40)
			make.height.equalTo(50)
		}
		
        
        self.view.backgroundColor = CommonColor.background.color

    }
    
    lazy var titleLB: UILabel = {
        let lb = UILabel.init(text: "Hi")
        lb.font = h_bfont(32)
        lb.textColor = CommonColor.subtitle.color
        return lb
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: AdaptScale(146), height: AdaptScale(168))
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        let collectionview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        let nib = UINib(nibName: String(describing: UserCenterCollectionViewCell.self), bundle: nil)
        let headernib = UINib(nibName: String(describing: UserCenterCollectionViewCell.self), bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        collectionview.backgroundColor = CommonColor.background.color
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
    }()
    
    var datasource: Array<[String:String]> = [["title":"近期收听","subtitle":"","imageName":"lishijilu"],
//                                           ["title":"我的收藏","subtitle":"","imageName":"mark"],
                                           ["title":"我的下载","subtitle":"","imageName":"download"],
                                           ["title":"我的订阅","subtitle":"","imageName":"handbag"],
                                           ["title":"设置","subtitle":"","imageName":"setting"],
                                           ]
}


extension UserCenterViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCenterCollectionViewCell
        cell.configCell(self.datasource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let historyVc = HistoryListViewController()
            self.navigationController?.pushViewController(historyVc)
        }
        
//        if indexPath.row == 1 {
//            let favorVc = FavouriteListController()
//            self.navigationController?.pushViewController(favorVc)
//        }
		
        if indexPath.row == 1 {
            let downloadVc = DownloadListController()
            self.navigationController?.pushViewController(downloadVc)
        }
        
        if indexPath.row == 2 {
            let subscribVc = PodListViewController()
            self.navigationController?.pushViewController(subscribVc)
        }
        
        if indexPath.row == 3 {
            let setvc = SettingViewController()
            self.navigationController?.pushViewController(setvc)
        }
    }
}
