//
//  SettingViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import StoreKit

class SettingViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.view.backgroundColor = CommonColor.background.color
        self.tableview.backgroundColor = CommonColor.background.color
        self.setUpDataSource()
        self.dw_addsubviews()
    }
    
    lazy var datasource : Array = {return []}()
	lazy var settings : Array = {return []}()
	lazy var feedbacks : Array = {return []}()
    lazy var others : Array = {return []}()
    
    func setUpDataSource (){
        if PrivacyManager.isOpenPusn() {
            self.settings.append(["title":"接收通知","imageName":"notify","rightImage":"icon_correct"])
        }else{
            self.settings.append(["title":"接收通知","imageName":"notify"])
        }
        self.feedbacks.append(["title":"github issue","imageName":"github"])
        self.others.append(["title":"给 FunnyFM 评分","imageName":"rate"])
        self.others.append(["title":"将 FunnyFM 推荐给好友","imageName":"share"])
        self.others.append(["title":"查看开发者其他的 App ","imageName":"github"])
    }
    
    func toShare(){
        let textToShare = "FunnyFM"
        let subtitleToShare = "有趣的播客由你自己发掘"
        let imageToShare = UIImage.init(named: "logo-white")
        let urlToShare = NSURL.init(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1447922692")
        var items = [textToShare,subtitleToShare,imageToShare!] as [Any]
        if urlToShare != nil {
            items.append(urlToShare!)
        }
        let activityVC = VisualActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func toGrade() {
        SKStoreReviewController.requestReview()
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
    
    lazy var titleLB: UILabel = {
        let lb = UILabel.init(text: "设置")
        lb.font = p_bfont(32)
        lb.textColor = CommonColor.subtitle.color
        return lb
    }()
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: SettingTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        table.rowHeight = 50
		table.sectionHeaderHeight = 30
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
}


extension SettingViewController {
	
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		if indexPath.section == 0{
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
			return
		}
        
        if indexPath.section == 1{
            if indexPath.row == 0 {
                UIApplication.shared.open(URL.init(string: "https://github.com/94haox/FunnyFM-issue/issues")!, options: [:], completionHandler:     nil)
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
		let lb = UILabel.init(text: "通知")
		lb.backgroundColor = CommonColor.background.color
		lb.textColor = CommonColor.subtitle.color
		lb.font = pfont(fontsize2)
		if section == 1 {
			lb.text = "反馈"
		}
        
        if section == 2 {
            lb.text = "关于"
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
		cell.backgroundColor = CommonColor.cellbackgroud.color
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
        self.view.addSubview(self.tableview)
        self.view.addSubview(self.titleLB)
        
        self.titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.left.equalToSuperview().offset(16)
        }
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.titleLB.snp.bottom)
        }
    }
}
