//
//  ImpactManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/1.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class ImpactManager: NSObject {
	
	static func impact( _ style: UIImpactFeedbackGenerator.FeedbackStyle = .light){
		let generator = UIImpactFeedbackGenerator.init(style: style)
		generator.impactOccurred()
	}
	

}
