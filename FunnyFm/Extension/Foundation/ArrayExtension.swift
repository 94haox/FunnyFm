//
//  ArrayExtension.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/18.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation


extension Array {
	
	func safeObj(index: Int) -> Any?{
		
		if self.count > index {
			return self[index] as? Any
		}
		
		return nil
	}
	
	
}
