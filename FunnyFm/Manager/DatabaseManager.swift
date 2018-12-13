//
//  DatabaseManager.swift
//  Macmillan700
//
//  Created by Duke on 2018/10/18.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import WCDBSwift

let historyTable = "listenHistory"
let progressTable = "chapter_progress"

class DatabaseManager: NSObject {
    
    
    static public var database : Database = Database(withFileURL: FunnyFm.sharedDatabaseUrl())
    
    static func setupDefaultDatabase(){
        try! database.create(table: historyTable, of: ListenHistoryModel.self)
        try! database.create(table: progressTable, of: ChapterProgress.self)
    }
    
    static public func add(history:ListenHistoryModel){
        let exsithistory = self.qurey(chapterId: history.chapterId!)
        if exsithistory.isSome {
            return
        }
        try! self.database.insert(objects: history, intoTable: historyTable)
    }
    
    static public func qurey(chapterId: String) -> ListenHistoryModel?{
        let historyList = self.allHistory()
        let history = historyList.filter { $0.chapterId! == chapterId }
        return history.first
    }
    
    static public func delete(chapterId: String){
        try! database.delete(fromTable: historyTable,
                            where: ListenHistoryModel.Properties.chapterId == chapterId)
    }
    
    static public func add(progress:ChapterProgress){
        let exsitProgress = self.qureyProgress(chapterId: progress.chapterId!)
        if exsitProgress.isSome {
            self.updateProgress(progress: progress)
            return
        }
        try! self.database.insert(objects: progress, intoTable: progressTable)
    }
    
    static public func qureyProgress(chapterId: String) -> ChapterProgress?{
        let progressList = self.allProgress()
        let progress = progressList.filter { $0.chapterId! == chapterId }
        return progress.first
    }
    
    static public func updateProgress(progress: ChapterProgress){
        let row : [ColumnEncodable] = ["update"]
        try! database.update(table: progressTable, on: [ChapterProgress.Properties.chapterId], with: row, where: ChapterProgress.Properties.chapterId.stringValue == progress.chapterId, orderBy: nil, limit: nil, offset: nil)
    }
    
    static public func deleteProgress(chapterId: String){
        try! database.delete(fromTable: historyTable,
                             where: ChapterProgress.Properties.chapterId == chapterId)
    }
    
    
    static public func allHistory() -> [ListenHistoryModel]{
        let historyList : [ListenHistoryModel] = try! database.getObjects(fromTable: historyTable)
        return historyList
    }
    
    static public func allProgress() -> [ChapterProgress]{
        let ChapterProgressList : [ChapterProgress] = try! database.getObjects(fromTable: progressTable)
        return ChapterProgressList
    }
    
    
    
    

}
