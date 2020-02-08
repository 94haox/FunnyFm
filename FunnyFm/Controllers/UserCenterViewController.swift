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
		NotificationCenter.default.addObserver(self, selector: #selector(updateAccountStatus), name: NSNotification.Name.init(kParserNotification), object: nil)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.updateAccountStatus()
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
		self.updateAccountStatus()
	}
	
	
	@objc func updateAccountStatus(){
        
        guard !ClientConfig.shared.isIPad else {
            return
        }
        
		if UserCenter.shared.isLogin {
			if UserCenter.shared.name.length() > 0 {
				self.titleLB.text = "Hi  \(UserCenter.shared.name)"
			}
			logoutBtn.setTitle("退出登录".localized, for: .normal)
		}else{
			logoutBtn.setTitle("登录".localized, for: .normal)
		}
	}
    
    func dw_addSubviews(){
		
        self.view.addSubview(self.collectionView)
		
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLB.snp.bottom)
            make.left.width.bottom.equalToSuperview()
        }
		
        if ClientConfig.shared.isIPad {
            return
        }
		self.logoutBtn = UIButton.init(type: .custom)
		logoutBtn.setTitleColor(.white, for: .normal)
		logoutBtn.backgroundColor = CommonColor.mainRed.color
		logoutBtn.cornerRadius = 5.0
		logoutBtn.titleLabel?.font = p_bfont(12);
		logoutBtn.addTarget(self, action: #selector(toLogoutAction), for: .touchUpInside)
		self.view.addSubview(self.logoutBtn)
		self.logoutBtn.snp.makeConstraints { (make) in
			make.baseline.equalTo(self.titleLB)
			make.right.equalTo(-18)
			make.width.equalTo(100.auto())
			make.height.equalTo(30.auto())
		}
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 146.auto(), height: 170.auto())
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets.init(top: 30.auto(), left: 30, bottom: toolbarH*2, right: 30)
        let collectionview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        let nib = UINib(nibName: String(describing: UserCenterCollectionViewCell.self), bundle: nil)
        let headernib = UINib(nibName: String(describing: UserCenterCollectionViewCell.self), bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        collectionview.delegate = self
        collectionview.dataSource = self
		collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = CommonColor.white.color
        return collectionview
    }()
    
    var datasource: Array<[String:String]> = [["title":"近期收听".localized,"subtitle":"","imageName":"lishijilu"],
                                           ["title":"我的下载".localized,"subtitle":"","imageName":"download"],
                                           ["title":"我的订阅".localized,"subtitle":"","imageName":"handbag"],
                                           ["title":"消息".localized,"subtitle":"服务消息".localized,"imageName":"message"],
                                           ["title":"设置".localized,"subtitle":"","imageName":"setting"],
										["title":"Ad".localized,"subtitle":"看个广告激励作者".localized,"imageName":"Ad"],
                                           ]
	
	//["title":"Pro","subtitle":"订购 Pro".localized,"imageName":"VIP"],
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
		
		if indexPath.row == 4 {
			let setvc = SettingViewController()
			self.navigationController?.pushViewController(setvc)
			return
		}
		
//		if indexPath.row == 5 {
//			let vipVC = VIPViewController()
//			self.navigationController?.pushViewController(vipVC)
//			return
//		}
		
		if indexPath.row == 3 {
			let msgVC = MessageViewController.init()
			self.navigationController?.pushViewController(msgVC)
			return
		}
		
		if indexPath.row == 5 {
			let adVC = AdShowViewController()
			self.navigationController?.pushViewController(adVC)
			return
		}
		
		if indexPath.row == 1 {
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
