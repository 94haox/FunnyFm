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
    
    /// 添加旋转动画
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
    
    /// 移除旋转动画
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
	
	/// 添加移动动画
	static func addMoveAnimation(_ layer: CALayer) {
		if let anim = POPBasicAnimation(propertyNamed: kPOPLayerPositionX){
			anim.fromValue = -kScreenWidth/2.0
			anim.toValue = 50
			anim.duration = 0.5
			anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
			layer.pop_add(anim, forKey: "view_move")
			anim.completionBlock = { (animation, complete) in
				
			}
		}
		
	}
	
	/// 添加缩小动画
	static func addScaleMinAnimation(_ layer: CALayer) {
		
		if let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY){
			anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
			anim.toValue = NSValue.init(cgPoint: CGPoint.init(x: 0.8, y: 0.8))
			anim.duration = 0.1
			layer.pop_add(anim, forKey: "view_scale_min")
			anim.completionBlock = { (animation, complete) in
				
			}
		}
		
	}

}
