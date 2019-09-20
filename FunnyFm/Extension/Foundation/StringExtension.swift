//
//  StringExtension.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/7.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation


extension String {
    
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toFloat() -> Float? {
        return Float(self)
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    //MARK:- 去除字符串两端的空白字符
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    //MARK:- 字符串长度
    func length() -> Int {
        return self.count
    }
    
    func indexOf(_ target: Character) -> Int? {
        return self.index(of: target)?.encodedOffset
    }
    
    func subString(to: Int) -> String {
        let endIndex = String.Index.init(encodedOffset: to)
        let subStr = self[self.startIndex..<endIndex]
        return String(subStr)
    }
    
    func subString(from: Int) -> String {
        let startIndex = String.Index.init(encodedOffset: from)
        let subStr = self[startIndex..<self.endIndex]
        return String(subStr)
    }
    
    func subString(start: Int, end: Int) -> String {
        let startIndex = String.Index.init(encodedOffset: start)
        let endIndex = String.Index.init(encodedOffset: end)
        return String(self[startIndex..<endIndex])
    }
    
    func subString(range: Range<String.Index>) -> String {
        return String(self[range.lowerBound..<range.upperBound])
    }
	
	func getFileSize() -> UInt64  {
		var size: UInt64 = 0
		let fileManager = FileManager.default
		var isDir: ObjCBool = false
		let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
		// 判断文件存在
		if isExists {
			// 是否为文件夹
			if isDir.boolValue {
				// 迭代器 存放文件夹下的所有文件名
				let enumerator = fileManager.enumerator(atPath: self)
				for subPath in enumerator! {
					// 获得全路径
					let fullPath = self.appending("/\(subPath)")
					do {
						let attr = try fileManager.attributesOfItem(atPath: fullPath)
						size += attr[FileAttributeKey.size] as! UInt64
					} catch  {
						print("error :\(error)")
					}
				}
			} else {    // 单文件
				do {
					let attr = try fileManager.attributesOfItem(atPath: self)
					size += attr[FileAttributeKey.size] as! UInt64
					
				} catch  {
					print("error :\(error)")
				}
			}
		}
		return size
	}
    
}

