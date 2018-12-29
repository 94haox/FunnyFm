//
//  AnimationRectAngle.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import pop

class AnimationRectAngle: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.line1)
        self.addSubview(self.line2)
        self.addSubview(self.line3)
        self.line1.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(5)
            make.height.equalTo(10)
        }
        
        self.line2.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(self.line1.snp.right).offset(4)
            make.width.equalTo(5)
            make.height.equalTo(10)
        }
        
        self.line3.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(self.line2.snp.right).offset(4)
            make.width.equalTo(5)
            make.height.equalTo(10)
        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleY){
            anim.fromValue = 1
            anim.toValue = 3
            anim.duration = 1.2
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            anim.repeatCount = NSIntegerMax
            self.line1.layer.pop_add(anim, forKey: "ScaleY")
        }
        
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleY){
            anim.fromValue = 1
            anim.toValue = 3
            anim.duration = 1.6
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            anim.repeatCount = NSIntegerMax
            self.line2.layer.pop_add(anim, forKey: "ScaleY")

        }
        
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleY){
            anim.fromValue = 1
            anim.toValue = 3
            anim.duration = 2.0
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            anim.repeatCount = NSIntegerMax
            self.line3.layer.pop_add(anim, forKey: "ScaleY")
        }
    }
    
    func stopAnimation() {
        
    }
    
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
        view.backgroundColor = CommonColor.mainRed.color
        return view
    }()

}
