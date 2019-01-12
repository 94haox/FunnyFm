//
//  HorizonHUD.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/12.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Lottie
import pop


class HorizonHUD: NSObject {
	
	static func showSuccess(_ text: String) {
		let doneView = LOTAnimationView.init(name: "done_button", bundle: Bundle.main)
		let hud = UIView.init(frame: CGRect.init(x: -kScreenWidth/2.0, y: kScreenHeight/4.0*3, width: kScreenWidth/2.0, height: 50))
		let lb = UILabel.init(text: text)
		lb.textColor = .white
		lb.font = p_bfont(14)
		hud.cornerRadius = 25
		hud.backgroundColor = UIColor.init(hex: "#333333")
		hud.addSubview(doneView)
		hud.addSubview(lb)
		UIApplication.shared.keyWindow!.addSubview(hud)
		doneView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(50);
			make.centerY.equalToSuperview()
			make.size.equalTo(CGSize.init(width: 50, height: 50))
		}
		
		lb.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().offset(-25)
		}
		
		if let anim = POPBasicAnimation(propertyNamed: kPOPLayerPositionX){
			anim.fromValue = -kScreenWidth/2.0
			anim.toValue = 50
			anim.duration = 0.5
			anim.timingFunction = CAMediaTimingFunction(name: .easeIn)
			hud.layer.pop_add(anim, forKey: "view_move")
			anim.completionBlock = { (animation, complete) in
				doneView.play()
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
					hud.layer.pop_removeAllAnimations()
					if let moveAnim = POPBasicAnimation(propertyNamed: kPOPLayerPositionX){
						moveAnim.toValue = -kScreenWidth/2.0
						moveAnim.fromValue = 50
						moveAnim.duration = 0.5
						moveAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
						hud.layer.pop_add(moveAnim, forKey: "view_move1")
						moveAnim.completionBlock = { (animation, complete) in
							hud.removeFromSuperview()
						}
					}
				})
			}
		}
	}
	
}
