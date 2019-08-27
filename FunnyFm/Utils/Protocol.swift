//
//  protocol.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation

// MARK: 代理
@objc protocol ViewModelDelegate {
    func viewModelDidGetDataSuccess()
    func viewModelDidGetDataFailture(msg:String?)
}


@objc protocol ChapterProgressDelegate {
	func progressDidChange(progress:CGFloat)
	func progressDidEndDrag()
}
