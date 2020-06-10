//
//  SettingViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import SafariServices

class SettingViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate {

	var logoutBtn: UIButton!
    
    var tableview : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "设置".localized
        self.setupUI()
        self.dw_addsubviews()
        self.setUpImmutableData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccountStatus), name: NSNotification.Name.init(kParserNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setUpDataSource), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setUpDataSource()
        self.updateAccountStatus()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
    
    lazy var datasource : Array = {return []}()
	lazy var settings : Array = {return []}()
	lazy var functions : Array = {return []}()
	lazy var feedbacks : Array = {return []}()
    lazy var others : Array = {return []}()
    
    @objc func setUpDataSource (){
		self.settings.removeAll()
        if PrivacyManager.isOpenPusn() {
            self.settings.append(["title":"接收通知".localized,"imageName":"notify","rightImage":"icon_correct"])
        }else{
            self.settings.append(["title":"接收通知".localized,"imageName":"notify"])
        }
        self.tableview.reloadData()
    }
	
	func setUpImmutableData(){
        var cache = Double(BCQResourceUtils.shared.getAllCacheSize()/1024/1024)
		if cache != 0 {
            if cache > 1024 {
                cache = cache/1024.0
                self.functions.append(["title":"清除缓存".localized,"imageName":"cache","rightText":String(format: "%.2f G", cache)])
            }else{
                self.functions.append(["title":"清除缓存".localized,"imageName":"cache","rightText":String(format: "%.0f M", cache)])
            }
		}else{
            self.functions.append(["title":"清除缓存".localized,"imageName":"cache"])
		}
		
		if FunnyFm.isAutoCacheInWIFI() {
			self.functions.append(["title":"WIFI 下自动缓存".localized,"imageName":"notify","rightImage":"icon_correct"])
		}else{
			self.functions.append(["title":"WIFI 下自动缓存".localized,"imageName":"notify"])
		}

		self.feedbacks.append(["title":"Feedback","imageName":"github"])
		self.others.append(["title":"给 FunnyFM 评分".localized,"imageName":"rate"])
		self.others.append(["title":"将 FunnyFM 推荐给好友".localized,"imageName":"share"])
		self.others.append(["title":"查看开发者其他的 App".localized,"imageName":"github"])
        self.others.append(["title":"使用指南".localized,"imageName":"guide"])
        self.others.append(["title":"关于".localized,"imageName":"about us"])
        self.tableview.reloadData()
	}
    
    func toShare(){
        let textToShare = "嘿，我发现了一个好用的播客 APP， 你也来试试吧".localized
        let imageToShare = UIImage.init(named: "logo-white")
        let urlToShare = NSURL.init(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1447922692")
        var items = [textToShare,imageToShare!] as [Any]
        if urlToShare != nil {
            items.append(urlToShare!)
        }
        let activityVC = VisualActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func toGrade() {
        SKStoreReviewController.requestReview()
    }
	
	func cleanAllCache(){
        Hud.shared.show(on: self.view)
        BCQResourceUtils.shared.cleanAllCache()
        let cache = BCQResourceUtils.shared.getAllCacheSize()/1024/1024
		if cache != 0 {
			self.functions[0] = ["title":"清除缓存","imageName":"cache","rightText":"\(cache)M"]
		}else{
			self.functions[0] = ["title":"清除缓存","imageName":"cache"]
		}
        Hud.shared.hide()
		self.tableview.reloadData()
		SwiftNotice.showText("缓存清除成功🎉")
	}
	
	func setupIsAutoCache() {
		UserDefaults.standard.set(!FunnyFm.isAutoCacheInWIFI(), forKey: "isAutoCacheInWIFI")
		if FunnyFm.isAutoCacheInWIFI() {
			self.functions[1] = ["title":"WIFI 下自动缓存".localized,"imageName":"notify","rightImage":"icon_correct"]
		}else{
			self.functions[1] = ["title":"WIFI 下自动缓存".localized,"imageName":"notify"]
		}
		self.tableview.reloadData()
	}
	
	func toAboutUs(){
        let aboutVC = AboutViewController()
        self.navigationController?.pushViewController(aboutVC)
	}
    
    func toAppStore() {
    
        let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1447922692")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
    }
    
    @objc func backAction(){
        self.navigationController?.popViewController()
    }
    
    @objc func toLogoutAction(){
        
        if !UserCenter.shared.isLogin {
            guard VipManager.shared.isVip else {
                self.alertVip()
                return
            }
            
            let loginNavi = UINavigationController.init(rootViewController: AppleLoginTypeViewController.init())
            loginNavi.navigationBar.isHidden = true
            self.navigationController?.dw_presentAsStork(controller: loginNavi, heigth: kScreenHeight, delegate: self)
            return
        }
        
        UserCenter.shared.isLogin = false
        HorizonHUD.showSuccess("退出成功".localized)
        self.updateAccountStatus()
    }
    
    @objc func updateAccountStatus(){
        if UserCenter.shared.isLogin {
            logoutBtn.setTitleForAllStates("退出登录".localized)
        }else{
            logoutBtn.setTitleForAllStates("登录".localized)
        }
    }
    
}


extension SettingViewController {
	
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		if indexPath.section == 0{
			if indexPath.row == 1 {
				self.setupIsAutoCache()
			}else{
				self.cleanAllCache()
			}
		}
		
		if indexPath.section == 1{
            if indexPath.row == 0 {
                if PrivacyManager.isConfigAPNS {
                    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }else{
                    AppDelegate.current.setupJpush()
                }
            }else{
                if VipManager.shared.isVip {
                    self.setUpDataSource()
                    tableView.reloadData()
                }else{
                    
                }
            }
			return
		}
        
        if indexPath.section == 2{
            if indexPath.row == 0 {
				let feedbackVC = FeedbackViewController.init()
				self.navigationController?.pushViewController(feedbackVC)
            }
			
			if indexPath.row == 1 {
				self.cleanAllCache()
			}
        }
        
        if indexPath.section == 3{
            if indexPath.row == 0 {
                self.toGrade()
            }
            
            if indexPath.row == 1{
                self.toShare()
            }
            
            if indexPath.row == 2{
                self.toAppStore()
            }
			
			if indexPath.row == 4{
				self.toAboutUs()
			}
            
            if indexPath.row == 3 {
                let vc = SFSafariViewController.init(url: URL.init(string: "https://live.funnyfm.top/#/guide")!)
                self.present(vc, animated: true, completion: nil)
            }
        }
		
		
		
    }
    
    
}

extension SettingViewController {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return self.functions.count
		}
		
		if section == 1 {
			return self.settings.count
		}
        
        if section == 2 {
            return self.feedbacks.count
        }
		
		return self.others.count
	}
	
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView.init()
		view.backgroundColor = R.color.ffWhite()
		let lb = UILabel.init(text: "通用".localized)
		lb.textColor = CommonColor.subtitle.color
		lb.font = pfont(fontsize2)
		
		if section == 1 {
			lb.text = "通知".localized
		}
		
		if section == 2 {
			lb.text = "反馈".localized
		}
        
        if section == 3 {
            lb.text = "关于".localized
        }
		view.addSubview(lb)
		lb.snp.makeConstraints { (make) in
			make.top.height.right.equalToSuperview()
			make.left.equalToSuperview().offset(17)
		}
		return view
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
		
		if indexPath.section == 0 {
			let item = self.functions[indexPath.row] as! Dictionary<String,String>
			cell.config(dic: item)
		}else if indexPath.section == 1 {
			let item = self.settings[indexPath.row] as! Dictionary<String,String>
			cell.config(dic: item)
		}else if indexPath.section == 2{
			let item = self.feedbacks[indexPath.row] as! Dictionary<String,String>
			cell.config(dic: item)
        }else{
            let item = self.others[indexPath.row] as! Dictionary<String,String>
            cell.config(dic: item)
        }
		
		return cell
	}
}

extension SettingViewController {
    
    func dw_addsubviews(){
        self.view.addSubview(self.tableview)
		
        self.tableview.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.top.height.equalToSuperview()
        }
		
//		self.logoutBtn.snp.makeConstraints { (make) in
//			make.centerX.equalToSuperview()
//		}
    }
    
    func setupUI(){
		
		let footView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40.auto()))
        
        self.logoutBtn = UIButton.init(type: .custom)
        logoutBtn.setTitleColorForAllStates(.white)
        logoutBtn.backgroundColor = R.color.mainRed()
        logoutBtn.cornerRadius = 5.0
        logoutBtn.titleLabel?.font = p_bfont(12);
        logoutBtn.addTarget(self, action: #selector(toLogoutAction), for: .touchUpInside)
		logoutBtn.frame = CGRect(x: (kScreenWidth -  200.auto())/2.0, y: 0, width: 200.auto(), height: 40.auto())
		
		footView.addSubview(logoutBtn)
		
        self.view.backgroundColor = R.color.background()
        self.tableview = UITableView.init(frame: CGRect.zero, style: .insetGrouped)
        let nib = UINib(nibName: String(describing: SettingTableViewCell.self), bundle: nil)
        self.tableview.register(nib, forCellReuseIdentifier: "cell")
        self.tableview.separatorStyle = .none
        self.tableview.rowHeight = 50
        self.tableview.sectionHeaderHeight = 30
        self.tableview.delegate = self
        self.tableview.dataSource = self
		self.tableview.tableFooterView = footView
        self.tableview.showsVerticalScrollIndicator = false
        self.tableview.backgroundColor = R.color.ffWhite()
		self.tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 150.auto(), right: 0)
	
        
    }
}
