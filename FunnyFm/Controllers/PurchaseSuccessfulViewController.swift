//
//  PurchaseSuccessfulViewController.swift
//  FunnyFm
//
//  Created by wt on 2020/3/19.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class PurchaseSuccessfulViewController: BaseViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var vaildTimeLB: UILabel!
    @IBOutlet weak var featureView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        self.featureView.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        self.titleLB.text = "订阅详情".localized
        self.view.backgroundColor = R.color.ffWhite()
        if self.navigationController!.viewControllers.count > 2 {
            self.backNaviBtn.isHidden = false
        }
        self.vaildTimeLB.text = "订阅截止日期：".localized + VipManager.shared.vipVaildDate!.string()
        self.backNaviBtn.addTarget(self, action: #selector(backToRoot), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FMToolBar.shared.isHidden = true
        if self.navigationController!.viewControllers.count > 2 {
            self.navigationController?.sh_fullscreenPopGestureRecognizer.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if FMToolBar.shared.currentEpisode.isSome {
            FMToolBar.shared.isHidden = false
        }
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
