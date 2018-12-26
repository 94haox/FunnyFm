//
//  AnimationRectAngle.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class AnimationRectAngle: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.line1)
        self.addSubview(self.line2)
        self.addSubview(self.line3)
        self.addSubview(self.line4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        
    }
    
    func stopAnimation() {
        
    }
    
    
    
    lazy var line4 : UIView = {
        let view = UIView.init()
        view.backgroundColor = CommonColor.mainRed.color
        return view
    }()
    
    lazy var line3 : UIView = {
        let view = UIView.init()
        view.backgroundColor = CommonColor.mainRed.color
        return view
    }()
    
    lazy var line2 : UIView = {
        let view = UIView.init()
        view.backgroundColor = CommonColor.mainRed.color
        return view
    }()
    
    lazy var line1 : UIView = {
        let view = UIView.init()
        return view
    }()

}
