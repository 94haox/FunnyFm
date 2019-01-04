//
//  DatabaseManager.swift
//  Macmillan700
//
//  Created by Duke on 2018/10/18.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import WCDBSwift

let downloadTable = "downloadTable"
let historyTable = "listenHistory"
let progressTable = "chapter_progress"

class DatabaseManager: NSObject {
    
    
    static public var database : Database = Database(withFileURL: FunnyFm.sharedDatabaseUrl())
    
    static func setupDefaultDatabase(){
        try! database.create(table: historyTable, of: ListenHistoryModel.self)
        try! database.create(table: progressTable, of: ChapterProgress.self)
        try! database.create(table: downloadTable, of: Episode.self)
    }
    
    /// 添加历史记录
    ///
    /// - Parameter history: 历史记录
    static public func add(history:ListenHistoryModel){
        let exsithistory = self.qurey(chapterId: history.episodeId!)
        if exsithistory.isSome {
            return
        }
        try! self.database.insert(objects: history, intoTable: historyTable)
    }
	
    /// 添加下载记录
    ///
    /// - Parameter download:   下载记录
	static public func add(download:Episode){
		let exsitDownload = self.qurey(episodeId: download.episodeId)
		if exsitDownload.isSome {
			return
		}
		try! self.database.insert(objects: download, intoTable: downloadTable)
	}
	
    
    /// 添加进度记录
    ///
    /// - Parameter progress: 进度记录
	static public func add(progress:ChapterProgress){
		let exsitProgress = self.qureyProgress(chapterId: progress.episodeId!)
		if exsitProgress.isSome {
			self.updateProgress(progress: progress)
			return
		}
		try! self.database.insert(objects: progress, intoTable: progressTable)
	}
    
    /// 查询历史记录
    static public func qurey(chapterId: String) -> ListenHistoryModel?{
        let historyList = self.allHistory()
        let history = historyList.filter { $0.episodeId! == chapterId }
        return history.first
    }
    
    /// 查询下载记录
    static public func qurey(episodeId: String) -> Episode?{
        let episodeList = self.allDownload()
        let episode = episodeList.filter { $0.episodeId == episodeId }
        return episode.first
    }
    
    /// 查询进度记录
    static public func qureyProgress(chapterId: String) -> ChapterProgress?{
        let progressList = self.allProgress()
        let progress = progressList.filter { $0.episodeId! == chapterId }
        return progress.first
    }
    
    /// 删除历史记录
    static public func delete(chapterId: String){
        try! database.delete(fromTable: historyTable,
                            where: ListenHistoryModel.Properties.episodeId == chapterId)
    }
	
    /// 更新进度记录
    static public func updateProgress(progress: ChapterProgress){
        let row : [ColumnEncodable] = ["update"]
        try! database.update(table: progressTable, on: [ChapterProgress.Properties.episodeId], with: row, where: ChapterProgress.Properties.episodeId.stringValue == progress.episodeId, orderBy: nil, limit: nil, offset: nil)
    }
    
    /// 删除进度记录
    static public func deleteProgress(chapterId: String){
        try! database.delete(fromTable: historyTable,
                             where: ChapterProgress.Properties.episodeId == chapterId)
    }
    

    static public func allDownload() -> [Episode]{
        let episodeList : [Episode] = try! database.getObjects(fromTable: downloadTable)
        return episodeList
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
