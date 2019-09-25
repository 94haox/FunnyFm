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
		self.titleLB.text = "Hi"
        self.dw_addSubviews()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if UserCenter.shared.isLogin {
			if UserCenter.shared.name.length() > 0 {
				self.titleLB.text = "Hi  \(UserCenter.shared.name)"
			}
			logoutBtn.setTitle("退出登录".localized, for: .normal)
		}else{
			logoutBtn.setTitle("登录".localized, for: .normal)
		}
	}
	
	
	@objc func toLogoutAction(){
		
		if !UserCenter.shared.isLogin {
			if #available(iOS 13.0, *) {
				let loginNavi = UINavigationController.init(rootViewController: AppleLoginTypeViewController.init())
				loginNavi.navigationBar.isHidden = true
				self.navigationController?.dw_presentAsStork(controller: loginNavi, heigth: kScreenHeight, delegate: self)
				return
			}
			
			let loginNavi = UINavigationController.init(rootViewController: LoginTypeViewController.init())
			loginNavi.navigationBar.isHidden = true
			self.navigationController?.dw_presentAsStork(controller: loginNavi, heigth: kScreenHeight, delegate: self)
			return
		}
		
		UserCenter.shared.isLogin = false
		HorizonHUD.showSuccess("退出成功".localized)
		self.navigationController?.popViewController()
	}
    
    func dw_addSubviews(){
		
        self.view.addSubview(self.collectionView)
		
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLB.snp.bottom)
            make.left.width.bottom.equalToSuperview()
        }
		
		
		
		self.logoutBtn = UIButton.init(type: .custom)
		logoutBtn.setTitleColor(.white, for: .normal)
		logoutBtn.backgroundColor = CommonColor.mainRed.color
		logoutBtn.cornerRadius = 5.0
		logoutBtn.titleLabel?.font = p_bfont(14);
		logoutBtn.addTarget(self, action: #selector(toLogoutAction), for: .touchUpInside)
		self.view.addSubview(self.logoutBtn)
		self.logoutBtn.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-AdaptScale(40))
			make.width.equalToSuperview().offset(-40)
			make.height.equalTo(AdaptScale(50))
		}
		
        
        self.view.backgroundColor = CommonColor.background.color
		self.topBgView.backgroundColor = CommonColor.background.color;
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: AdaptScale(146), height: AdaptScale(170))
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets.init(top: 30.adapt(), left: 30, bottom: 120, right: 30)
        let collectionview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        let nib = UINib(nibName: String(describing: UserCenterCollectionViewCell.self), bundle: nil)
        let headernib = UINib(nibName: String(describing: UserCenterCollectionViewCell.self), bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        collectionview.backgroundColor = CommonColor.background.color
        collectionview.delegate = self
        collectionview.dataSource = self
		collectionview.showsVerticalScrollIndicator = false
        return collectionview
    }()
    
    var datasource: Array<[String:String]> = [["title":"近期收听".localized,"subtitle":"","imageName":"lishijilu"],
											  ["title":"播放列表".localized,"subtitle":"","imageName":"play-list-fill"],
                                           ["title":"我的下载".localized,"subtitle":"","imageName":"download"],
                                           ["title":"我的订阅".localized,"subtitle":"","imageName":"handbag"],
                                           ["title":"设置".localized,"subtitle":"","imageName":"setting"],
										["title":"Ad".localized,"subtitle":"看个广告激励作者".localized,"imageName":"Ad"],
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
		
		if indexPath.row == 3 {
			let setvc = SettingViewController()
			self.navigationController?.pushViewController(setvc)
			return
		}
		
		if indexPath.row == 4 {
			let adVC = AdShowViewController()
			self.navigationController?.pushViewController(adVC)
			return
		}
		
		if indexPath.row == 1 {
			let playlistVC = PlayListViewController()
			self.navigationController?.pushViewController(playlistVC)
			return
		}
		
		if indexPath.row == 2 {
			let downloadVc = DownloadListViewController()
			self.navigationController?.pushViewController(downloadVc)
			return
		}
		
		if !UserCenter.shared.isLogin {
			if #available(iOS 13.0, *) {
				let loginNavi = UINavigationController.init(rootViewController: AppleLoginTypeViewController.init())
				loginNavi.navigationBar.isHidden = true
				self.navigationController?.dw_presentAsStork(controller: loginNavi, heigth: kScreenHeight, delegate: self)
				return
			}
			let loginNavi = UINavigationController.init(rootViewController: LoginTypeViewController.init())
			self.navigationController?.present(loginNavi, animated: true, completion: nil)
			return
		}
		
        if indexPath.row == 0 {
            let historyVc = HistoryListViewController()
            self.navigationController?.pushViewController(historyVc)
        }
        
        if indexPath.row == 2 {
            let subscribVc = PodListViewController()
            self.navigationController?.pushViewController(subscribVc)
        }
    }
}
