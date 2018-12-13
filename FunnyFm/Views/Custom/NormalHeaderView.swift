//
//  NormalHeaderView.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class NormalHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CommonColor.background.color
        self.addSubview(self.titleLB)
        self.titleLB.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHeader(_ title:String){
        self.titleLB.text = title
    }
    
    lazy var titleLB : UILabel = {
        let lb = UILabel.init()
        lb.textColor = CommonColor.content.color
        lb.font = p_bfont(fontsize4)
        return lb
    }()
    
}
