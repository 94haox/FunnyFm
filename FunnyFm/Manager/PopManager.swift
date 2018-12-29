//
//  PopManager.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/28.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import pop

class PopManager: NSObject {
    
    static func addRotationAnimation(_ layer: CALayer) {
        let rotaionAnim = layer.pop_animation(forKey: "image_rotaion")
        if rotaionAnim != nil {
            let anim = rotaionAnim as! POPBasicAnimation
            anim.toValue = NSNumber.init(value:360)
            anim.duration = 360
            return
        }
        if let anim = POPBasicAnimation(propertyNamed: kPOPLayerRotation){
            anim.fromValue = NSNumber.init(value: 0)
            anim.toValue = NSNumber.init(value:360)
            anim.duration = 360
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            anim.repeatCount = NSIntegerMax
            layer.pop_add(anim, forKey: "image_rotaion")
        }
        
    }
    
    static func removeRotationAnimation(_ layer: CALayer) {
        let rotaionAnim = layer.pop_animation(forKey: "image_rotaion")
        if rotaionAnim == nil {
            return
        }
        let anim = layer.pop_animation(forKey: "image_rotaion") as! POPBasicAnimation
        anim.toValue = NSNumber.init(value: 0)
        anim.repeatCount = 1
        anim.duration = 0.5
    }

}
