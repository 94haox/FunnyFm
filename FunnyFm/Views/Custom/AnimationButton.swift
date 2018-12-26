//
//  AnimationButton.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/26.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import pop

class AnimationButton: UIButton {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        if let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
            anim.toValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
            anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1.2, y: 1.2))
            anim.springBounciness = 20
            self.layer.pop_add(anim, forKey: "size")
        }
        return super.beginTracking(touch, with: event)
    }
    

    
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        if let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
//            anim.toValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
//            anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1.5, y: 1.5))
//            anim.springBounciness = 30
//            self.layer.pop_add(anim, forKey: "size")
//        }
//    }


}
