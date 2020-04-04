//
//  UserLoginTipView.swift
//  FunnyFm
//
//  Created by wt on 2020/3/20.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import Lottie


class UserLoginTipView: UIView {
    
    let contentView = UIView.init(frame: CGRect.zero)
    
    var animationView : AnimationView = AnimationView(name:"login_tip")
    
    var tipLB: UILabel = UILabel.init(text: "想同步云端数据？快来登录吧!".localized)
    
    var btn: UIButton = UIButton.init(type: .custom)
    
    var actionClosure: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.animationView.loopMode = .loop
        self.setupUI()
        self.animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnAction() {
        if self.actionClosure.isSome {
            self.actionClosure!()
        }
    }
    
}

extension UserLoginTipView {
    
    func setupUI() {
        self.addSubview(self.contentView)
        self.cornerRadius = 12.auto()
        self.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        self.backgroundColor = CommonColor.whiteBackgroud.color
        self.tipLB.font = pfont(12.auto())
        self.tipLB.textColor = R.color.content()
        self.btn.setTitleForAllStates("登录".localized)
        self.btn.backgroundColor = R.color.mainRed()
        self.btn.cornerRadius = 5.auto()
        self.btn.titleLabel?.font = p_bfont(12.auto())
        self.btn.setTitleColor(.white, for: .normal)
        self.btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        self.contentView.addSubviews([self.animationView, self.tipLB, self.btn])
        self.contentView.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
            make.leading.equalTo(self.animationView)
            make.right.equalTo(self.tipLB)
        }
        self.animationView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16.auto())
            make.size.equalTo(CGSize.init(width: 80.auto(), height: 80.auto()))
        }
        
        self.tipLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.animationView.snp.right).offset(12.auto())
            make.bottom.equalTo(self.snp_centerY).offset(-6.auto())
        }
        
        self.btn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.tipLB)
            make.top.equalTo(self.snp_centerY).offset(6.auto())
            make.size.equalTo(CGSize.init(width: 100.auto(), height: 30.auto()))
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle == .dark {
            self.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        }else{
            self.cleanShadow()
        }
    }
    
}
