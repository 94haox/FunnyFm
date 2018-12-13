//
//  ChapterProgress.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import WCDBSwift

class ChapterProgress: TableCodable {
    var chapterId:              String?
    var progress:               Double
    
    init(chapterId:String, progress: Double) {
        self.chapterId = chapterId
        self.progress = progress
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ChapterProgress
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case chapterId
        case progress
    }
}
