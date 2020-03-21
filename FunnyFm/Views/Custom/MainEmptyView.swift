//
//  MainEmptyView.swift
//  FunnyFm
//
//  Created by wt on 2020/3/21.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import Lottie

class MainEmptyView: UIView {
    
    var addBtn : UIButton!
    var emptyAnimationView : AnimationView!
    var actionBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addEmptyViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnAction() {
        if self.actionBlock.isSome {
            self.actionBlock!()
        }
    }

    func addEmptyViews(){
        self.backgroundColor = CommonColor.white.color
        self.emptyAnimationView = AnimationView(name:"home_empty")
        self.emptyAnimationView.loopMode = .loop;
        
        self.addBtn = UIButton.init(type: .custom)
        addBtn.setTitle("发现播客".localized, for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = CommonColor.mainRed.color
        addBtn.cornerRadius = 15.0
        addBtn.titleLabel?.font = p_bfont(14);
        addBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        addBtn.addShadow(ofColor: CommonColor.mainPink.color, radius: 16, offset: CGSize.init(width: 0, height: 9), opacity: 0.6)
        
        self.addSubview(self.emptyAnimationView)
        self.emptyAnimationView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50.auto())
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 150.auto()))
        }
        
        let label = UILabel.init(text: "快来添加你的第一个播客吧".localized)
        label.textColor = .lightGray
        label.font = pfont(14);
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.emptyAnimationView.snp.bottom).offset(15.auto())
        }
        
        self.addSubview(self.addBtn);
        self.addBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(40.auto())
            make.width.equalToSuperview().offset(-100.auto())
            make.height.equalTo(50.auto())
        }
        
        self.emptyAnimationView.play()
        
    }

}
