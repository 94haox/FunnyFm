//
//  InPurchaseViewController.swift
//  FunnyFm
//
//  Created by Duke on 2020/2/11.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class InPurchaseViewController: BaseViewController {

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
        StoreManager.shared.getAllProducts()
        self.titleLB.text = "订购趣播客 Pro"
        infoTopConstraint.constant = 80.auto()
        infoHConstraint.constant = 150.auto()
        priceTopConstraint.constant = 100.auto()
        infoStack.backgroundColor = R.color.mainRed()
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
    
    func buyAction(btn: RoundedButton){
        if let seletedBtn = self.seletedBtn, seletedBtn.isBusy {
            return
        }
        self.seletedBtn = btn
        self.seletedBtn!.isBusy = true
    }
    
    
}
