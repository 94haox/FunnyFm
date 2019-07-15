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
let progressTable = "episode_progress"
let exsitEpisodeTable = "exsit_episode"
let exsitPodTable = "exsit_iTunsPod"

class DatabaseManager: NSObject {
    
    
    static public var database : Database = Database(withFileURL: FunnyFm.sharedDatabaseUrl())
    
    static func setupDefaultDatabase(){
		try! database.create(table: exsitPodTable, of: iTunsPod.self)
		try! database.create(table: exsitEpisodeTable, of: Episode.self)
        try! database.create(table: historyTable, of: Episode.self)
        try! database.create(table: progressTable, of: ChapterProgress.self)
        try! database.create(table: downloadTable, of: Episode.self)
    }
    
    /// 添加历史记录
    ///
    /// - Parameter history: 历史记录
    static public func add(history:Episode){
        let exsithistory = self.qurey(title: history.title)
        if exsithistory.isSome {
            return
        }
        try! self.database.insert(objects: history, intoTable: historyTable)
    }
	
    /// 添加下载记录
    ///
    /// - Parameter download:   下载记录
	static public func add(download:Episode){
		let exsitDownload = self.qureyDownload(title: download.title)
		if exsitDownload.isSome {
			return
		}
		try! self.database.insert(objects: download, intoTable: downloadTable)
	}
	
    
    /// 添加进度记录
    ///
    
    /// 查询历史记录
    static public func qurey(title: String) -> Episode?{
        let historyList = self.allHistory()
        let history = historyList.filter { $0.title == title }
        return history.first
    }
    
    /// 查询下载记录
    static public func qureyDownload(title: String) -> Episode?{
        let episodeList = self.allDownload()
        let episode = episodeList.filter { $0.title == title }
        return episode.first
    }
    
    /// 查询进度记录
    static public func qureyProgress(episodeId: String) -> Double{
		return UserDefaults.standard.double(forKey: "Progress_" + episodeId)
    }
    
    /// 删除历史记录
    static public func delete(title: String){
        try! database.delete(fromTable: historyTable,
                            where: Episode.Properties.title == title)
    }
	
    /// 更新进度记录
	static public func updateProgress(progress: Double, episodeId:String){
		UserDefaults.standard.set(progress, forKey: "Progress_" + episodeId)
		UserDefaults.standard.synchronize()
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
    
    static public func allHistory() -> [Episode]{
        let historyList : [Episode] = try! database.getObjects(fromTable: historyTable)
        return historyList
    }
    
    static public func allProgress() -> [ChapterProgress]{
        let ChapterProgressList : [ChapterProgress] = try! database.getObjects(fromTable: progressTable)
        return ChapterProgressList
    }
	
	
	/// pod 缓存
	static public func allItunsPod() -> [iTunsPod] {
		let itunsPodList : [iTunsPod] = try! database.getObjects(fromTable: exsitPodTable)
		return itunsPodList
	}
	
	static public func getItunsPod(collectionId:String) -> iTunsPod?{
		let podList = self.allItunsPod()
		let pod = podList.filter { $0.collectionId == collectionId }
		return pod.first
	}
	
	static public func addItunsPod(pod: iTunsPod){
		let exsitPod = self.getItunsPod(collectionId: pod.collectionId)
		if exsitPod.isSome {
			try! self.database.update(table: exsitPodTable, on: iTunsPod.Properties.all, with: pod, where: iTunsPod.Properties.collectionId == pod.collectionId)
			return
		}
		try! self.database.insert(objects: pod, intoTable: exsitPodTable)
	}
		
	static public func deleteItunsPod(pod: iTunsPod){
		try! self.database.delete(fromTable: exsitPodTable, where: iTunsPod.Properties.collectionId == pod.collectionId, orderBy: nil, limit: nil, offset: nil)
	}
	
	
	/// episode 缓存
	static public func allEpisodes() -> [Episode] {
		let episodeList : [Episode] = try! database.getObjects(fromTable: exsitEpisodeTable).sorted(by: { (obj1, obj2) -> Bool in
			let second1 = obj1.pubDateSecond
			let second2 = obj2.pubDateSecond
			return second1 >= second2
		})
		return episodeList
	}
	
	static public func getEpisode(title:String) -> Episode?{
		let episodeList = self.allEpisodes()
		let episodes = episodeList.filter { $0.title == title }
		return episodes.first
	}
	
	static public func addEpisode(episode: Episode){
		let exsitEpisode = self.getEpisode(title: episode.title)
		if exsitEpisode.isSome {
			return
		}
		try! self.database.insert(objects: episode, intoTable: exsitEpisodeTable)
	}
    
    

}
