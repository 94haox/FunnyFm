//
//  GuideTipView.swift
//  FunnyFm
//
//  Created by wt on 2020/4/8.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class GuideTipView: UIView {
    
    let showBtn = UIButton.init(type: .custom)
    
    let tipLB = UILabel.init(text: "使用指南".localized)
    
    let sumLB = UILabel.init(text: "通过使用指南了解『趣播客』的特色功能。".localized)
    
    let closeBtn = UIButton.init(type: .close)
    
    var closeClosure: (()->Void)?
    
    var readClosure: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeAction() {
        if self.closeClosure.isSome {
            self.closeClosure!()
        }
    }
    
    @objc func readAction() {
        if self.readClosure.isSome {
            self.closeClosure?()
            self.readClosure!()
        }
    }
    
    func configViews() {
        self.cornerRadius = 12.auto()
        showBtn.cornerRadius = 8.auto()
        self.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        self.backgroundColor = CommonColor.whiteBackgroud.color
        
        self.addSubviews([showBtn, tipLB, sumLB, closeBtn])
        showBtn.setTitleForAllStates("立即查看".localized)
        showBtn.titleLabel?.font = p_bfont(fontsize2)
        showBtn.backgroundColor = R.color.mainRed()
        showBtn.addTarget(self, action: #selector(readAction), for: .touchUpInside)
        
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        tipLB.font = p_bfont(titleFontSize)
        tipLB.textColor = R.color.titleColor()

        sumLB.font = pfont(fontsize2)
        sumLB.textColor = R.color.subtitle()
        
        tipLB.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16.auto())
        }
        
        sumLB.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLB.snp_bottom).offset(12.auto())
        }
        
        showBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-16.auto())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 90.auto(), height: 30.auto()))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8.auto())
            make.top.equalToSuperview().offset(8.auto())
        }
    }

}
