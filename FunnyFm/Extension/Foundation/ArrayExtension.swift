//
//  ArrayExtension.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/18.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation


extension Array {
	
	func safeObj<T:CodingKey>(index: Int) -> T{
		
		if index > self.count - 1 {
			return self.last! as! T
		}
		
		return self[index] as! T
	}
	
	
}
