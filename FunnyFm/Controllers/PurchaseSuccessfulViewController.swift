//
//  PurchaseSuccessfulViewController.swift
//  FunnyFm
//
//  Created by wt on 2020/3/19.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class PurchaseSuccessfulViewController: FirstViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var vaildTimeLB: UILabel!
    @IBOutlet weak var featureView: UIView!
    var infoBtn = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        self.featureView.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        self.title = "订阅详情".localized
        self.view.backgroundColor = R.color.ffWhite()
        if self.navigationController!.viewControllers.count > 2 {
            self.backNaviBtn.isHidden = false
        }
        self.vaildTimeLB.text = "订阅截止日期：".localized + VipManager.shared.vipVaildDate!.string()
        self.backNaviBtn.addTarget(self, action: #selector(backToRoot), for: .touchUpInside)
        self.topBgView.addSubview(infoBtn)
         self.infoBtn.snp.makeConstraints { (make) in
             make.right.equalToSuperview().offset(-12.auto())
             make.centerY.equalTo(self.titleLB)
         }
        self.infoBtn.setTitleForAllStates("协议与条款".localized)
        self.infoBtn.setTitleColorForAllStates(R.color.mainRed()!)
        self.infoBtn.titleLabel?.font = pfont(fontsize2)
        self.infoBtn.addTarget(self, action: #selector(toAboutVC), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: true)
        if self.navigationController!.viewControllers.count > 2 {
            self.navigationController?.sh_fullscreenPopGestureRecognizer.isEnabled = false
        }
    }
    
    @objc func toAboutVC() {
        let vc = AboutViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func backToRoot() {
        self.navigationController?.sh_fullscreenPopGestureRecognizer.isEnabled = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle == .dark {
            self.topView.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
            self.featureView.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        }else{
            self.topView.cleanShadow()
            self.featureView.cleanShadow()
        }
    }

}
