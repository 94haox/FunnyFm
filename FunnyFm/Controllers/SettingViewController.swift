//
//  SettingViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import StoreKit
import OneSignal

class SettingViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var titleLB: UILabel!
	
	var versionLB: UILabel!
    
    var tableview : UITableView!
    
    var backBtn : UIButton!
    
    var naviBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setUpImmutableData()
        self.setupUI()
        self.view.backgroundColor = .white
        self.dw_addsubviews()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setUpDataSource()
		self.tableview.reloadData()
	}
    
    lazy var datasource : Array = {return []}()
	lazy var settings : Array = {return []}()
	lazy var feedbacks : Array = {return []}()
    lazy var others : Array = {return []}()
    
    func setUpDataSource (){
		self.settings.removeAll()
        if PrivacyManager.isOpenPusn() {
            self.settings.append(["title":"接收通知".localized,"imageName":"notify","rightImage":"icon_correct"])
        }else{
            self.settings.append(["title":"接收通知".localized,"imageName":"notify"])
        }
    }
	
	func setUpImmutableData(){
		self.feedbacks.append(["title":"Feedback","imageName":"github"])
		self.others.append(["title":"给 FunnyFM 评分".localized,"imageName":"rate"])
		self.others.append(["title":"将 FunnyFM 推荐给好友".localized,"imageName":"share"])
		self.others.append(["title":"查看开发者其他的 App".localized,"imageName":"github"])
		self.others.append(["title":"关于 FunnyFM".localized,"imageName":"about us"])
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
	
	func toAboutUs(){
		let url = URL(string: "https://live.funnyfm.top/#/")
		var responder = self as UIResponder?
		let selectorOpenURL = sel_registerName("openURL:")
		
		while (responder != nil) {
			if (responder?.responds(to: selectorOpenURL))! {
				let _ = responder?.perform(selectorOpenURL, with: url)
			}
			responder = responder!.next
		}
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
    
    
}


extension SettingViewController {
	
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		if indexPath.section == 0{
//			NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kSetupNotification), object: nil)
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
			return
		}
        
        if indexPath.section == 1{
            if indexPath.row == 0 {
                UIApplication.shared.open(URL.init(string: "https://funnyfm.nolt.io")!, options: [:], completionHandler:     nil)
            }
        }
        
        if indexPath.section == 2{
            if indexPath.row == 0 {
                self.toGrade()
            }
            
            if indexPath.row == 1{
                self.toShare()
            }
            
            if indexPath.row == 2{
                self.toAppStore()
            }
			
			if indexPath.row == 3{
				self.toAboutUs()
			}
        }
		
		
		
    }
    
    
}

extension SettingViewController {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return self.settings.count
		}
        
        if section == 1 {
            return self.feedbacks.count
        }
		return self.others.count
	}
	
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView.init()
		view.backgroundColor = UIColor.white
		let lb = UILabel.init(text: "通知".localized)
		lb.textColor = CommonColor.subtitle.color
		lb.font = pfont(fontsize2)
		if section == 1 {
			lb.text = "反馈".localized
		}
        
        if section == 2 {
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
			let item = self.settings[indexPath.row] as! Dictionary<String,String>
			cell.config(dic: item)
		}else if indexPath.section == 1{
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
        self.view.addSubview(self.naviBar)
        self.view.addSubview(self.tableview)
        self.view.addSubview(self.titleLB)
        self.view.addSubview(self.backBtn)
		self.view.addSubview(self.versionLB)
        
        self.naviBar.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.top.equalTo(self.view.snp_topMargin)
            make.height.equalTo(44)
        }
        
        self.titleLB.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.naviBar)
            make.centerX.equalToSuperview()
        }
        
        self.backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.naviBar)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.naviBar.snp.bottom)
        }
		
		self.versionLB.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(self.view.snp.bottomMargin).offset(-15)
		}
    }
    
    func setupUI(){
        self.tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: SettingTableViewCell.self), bundle: nil)
        self.tableview.register(nib, forCellReuseIdentifier: "cell")
        self.tableview.separatorStyle = .none
        self.tableview.rowHeight = 50
        self.tableview.sectionHeaderHeight = 30
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.tableFooterView = UIView()
        self.tableview.showsVerticalScrollIndicator = false
        
        self.titleLB = UILabel.init(text: "设置".localized)
        self.titleLB.font = p_bfont(18)
        self.titleLB.textColor = CommonColor.title.color
        
        self.backBtn = UIButton.init(type: .custom)
        self.backBtn.setImage(UIImage.init(named: "back_black"), for: .normal)
        self.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        self.naviBar = UIView.init()
        self.naviBar.backgroundColor = .white
		
		let infoDic = Bundle.main.infoDictionary
		let appVersion = infoDic?["CFBundleShortVersionString"]
		let appBuildVersion = infoDic?["CFBundleVersion"]
		self.versionLB = UILabel.init(text: "Version: " + (appVersion as! String) + "(\((appBuildVersion as! String)))")
		self.versionLB.font = p_bfont(12)
		self.versionLB.textColor = CommonColor.content.color
        
    }
}
