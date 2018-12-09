//
//  HomePodListHeader.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/6.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class HomePodListHeader: UICollectionReusableView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel()
        label.text = "All"
        label.textColor = UIColor.init(hex: "464d5c")
		label.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
