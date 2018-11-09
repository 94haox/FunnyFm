//
//  FmToolBar.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class FmToolBar: UIView {
    
//    static let shared = FmToolBar.init(frame: CGRect.ini)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
