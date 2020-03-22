//
//  InPurchaseViewController.swift
//  FunnyFm
//
//  Created by Duke on 2020/2/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import Rswift

class InPurchaseViewController: BaseViewController {

    @IBOutlet weak var featureView: UIView!
    @IBOutlet weak var restoreBtn: RoundedButton!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var infoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoHConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceHConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthBtn: RoundedButton!
    @IBOutlet weak var yearBtn: RoundedButton!
    @IBOutlet weak var foreverBtn: RoundedButton!
    
    private var seletedBtn: RoundedButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.background()
        self.view.bringSubviewToFront(self.restoreBtn)
        self.titleLB.text = "解锁 Pro 功能".localized
        infoTopConstraint.constant = 80.auto()
        infoHConstraint.constant = 150.auto()
        priceTopConstraint.constant = 100.auto()
        self.featureView.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FMToolBar.shared.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if FMToolBar.shared.currentEpisode.isSome {
            FMToolBar.shared.isHidden = false
        }
    }

    @IBAction func monthAction(_ sender: RoundedButton) {
        self.buyAction(btn: self.monthBtn)
    }
    
    @IBAction func yearAction(_ sender: RoundedButton) {
        self.buyAction(btn: self.yearBtn)
    }
    
    @IBAction func foreverAction(_ sender: RoundedButton) {
        self.buyAction(btn: self.foreverBtn)
    }
    
    @IBAction func restoreAction(_ sender: RoundedButton) {
        sender.isBusy = true
        VipManager.shared.restorePurchase { (result) in
            sender.isBusy = false
            if result {
                VipManager.shared.allowEpisodeNoti = true
                DispatchQueue.main.async {
                    let successVC = PurchaseSuccessfulViewController()
                    self.navigationController?.pushViewController(successVC, animated: true)
                }
            }
        }
    }
    
    func buyAction(btn: RoundedButton){
        if let seletedBtn = self.seletedBtn, seletedBtn.isBusy {
            return
        }
        self.seletedBtn = btn
        self.seletedBtn!.isBusy = true
        VipManager.shared.purchaseProduct(productId: String(self.seletedBtn!.tag)) { (isSuccess) in
            self.seletedBtn?.isBusy = false
            if isSuccess {
                VipManager.shared.allowEpisodeNoti = true
                SwiftNotice.showText("购买成功")
            }else{
                SwiftNotice.showText("购买失败")
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle == .dark {
            self.featureView.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        }else{
            self.featureView.cleanShadow()
        }
    }

    
}
