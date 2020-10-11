//
//  DatabaseManager.swift
//  Macmillan700
//
//  Created by Duke on 2018/10/18.
//  Copyright © 2018 Duke. All rights reserved.
//

import WCDBSwift

let downloadTable = "downloadTable"
let historyTable = "listenHistory"
let progressTable = "episode_progress"
let exsitEpisodeTable = "exsit_episode"
let exsitPodTable = "exsit_iTunsPod"
let playItemTable = "play_list_table"

class DatabaseManager: NSObject {
    
    
    static public var database : Database = Database(withFileURL: FunnyFm.sharedDatabaseUrl())
    
    static func setupDefaultDatabase() {
		migrateFilePath()
		try! database.create(table: exsitPodTable, of: iTunsPod.self)
		try! database.create(table: exsitEpisodeTable, of: Episode.self)
        try! database.create(table: historyTable, of: Episode.self)
        try! database.create(table: progressTable, of: ChapterProgress.self)
        try! database.create(table: downloadTable, of: Episode.self)
		try! database.create(table: playItemTable, of: PlayItem.self)
    }
	
	static func migrateFilePath() {
		if let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
		   FileManager.default.fileExists(atPath: filePath.appendingPathComponent("FunnyFM.db").path)
		   {
			try! FileManager.default.moveItem(at: filePath.appendingPathComponent("FunnyFM.db"), to: FunnyFm.sharedDatabaseUrl())
		}
	}
	
}

// MARK: 播放列表操作记录
extension DatabaseManager {
	
	static public func add(item: PlayItem){
		let olditem = self.query(trackUrl: item.trackUrl)
		if olditem.isSome {
			self.update(item: item)
			return
		}
		try! database.insert(objects: item, intoTable: playItemTable)
		
	}
	
	
	static public func query(trackUrl: String) -> PlayItem?{
		let items: [PlayItem]? = try! database.getObjects(fromTable: playItemTable,
		where: PlayItem.Properties.trackUrl == trackUrl)
		if items.isSome {
			if items!.first.isSome {
				return items!.first!
			}
		}
		return nil
	}
	
	static public func update(item: PlayItem){
		let olditem: PlayItem? = self.query(trackUrl: item.trackUrl)
		if olditem.isSome {
			try! self.database.update(table: playItemTable, on: PlayItem.Properties.all, with: item, where: PlayItem.Properties.trackUrl == item.trackUrl)
		}
	}
	
	static public func deletePlayItem(trackUrl:String){
		try! database.delete(fromTable: playItemTable,
							 where: PlayItem.Properties.trackUrl == trackUrl)
	}
	
	static public func allPlayItem() -> [PlayItem] {
		let items : [PlayItem] = try! database.getObjects(fromTable: playItemTable)
		
		let sortedItems = items.sorted(by: { (item1, item2) -> Bool in
			return item1.playIndex < item2.playIndex
		})
		
		return sortedItems
	}
}



// MARK: 历史记录操作
extension DatabaseManager {
	
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
	
    static public func allHistory() -> [Episode]{
        let historyList : [Episode] = try! database.getObjects(fromTable: historyTable)
        return historyList
    }
	
    /// 删除历史记录
    static public func delete(title: String){
        try! database.delete(fromTable: historyTable,
                            where: Episode.Properties.title == title)
    }
	
    /// 查询历史记录
    static public func qurey(title: String) -> Episode?{
        let historyList = self.allHistory()
        let history = historyList.filter { $0.title == title }
        return history.first
    }
	
}

// MARK: 下载记录操作
extension DatabaseManager {
	
    static public func allDownload() -> [Episode]{
        let episodeList : [Episode] = try! database.getObjects(fromTable: downloadTable)
        return episodeList
    }
	
	static public func deleteDownload(title: String){
		try! database.delete(fromTable: downloadTable,
							 where: Episode.Properties.title == title)
			
	}
	
    /// 查询下载记录
    static public func qureyDownload(title: String) -> Episode?{
        let episodeList = self.allDownload()
        let episode = episodeList.filter { $0.title == title }
        return episode.first
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
	
}

// MARK: Podcast 操作
extension DatabaseManager {
	/// pod 缓存
	static public func allItunsPod() -> [iTunsPod] {
		var itunsPodList : [iTunsPod] = try! database.getObjects(fromTable: exsitPodTable)
		itunsPodList = itunsPodList.reversed()
		return itunsPodList
	}
	
	static public func getPodcast(podId: String) -> iTunsPod?{
		let podList: [iTunsPod] = try! database.getObjects(fromTable: exsitPodTable,
											   where: iTunsPod.Properties.podId == podId)
		return podList.first
	}
	
	static public func getPodcast(feedUrl: String) -> iTunsPod?{
		let podList: [iTunsPod] = try! database.getObjects(fromTable: exsitPodTable,
											   where: iTunsPod.Properties.feedUrl == feedUrl)
		if podList.count > 1 {
			for (index,pod) in podList.enumerated() {
				if index != 0 {
					self.deleteItunsPod(feedUrl: pod.feedUrl)
				}
			}
		}
		return podList.first
	}
    
    static public func getLastEpisodeTitle(feedUrl: String) -> (String, iTunsPod?) {
        var last_title = ""
        let pod = DatabaseManager.getPodcast(feedUrl: feedUrl)
        if pod.isSome {
            let episodeList = DatabaseManager.allEpisodes(pod: pod!)
            if let episode = episodeList.first {
                last_title = episode.title
            }
        }
        return (last_title, pod)
    }
	
	static public func addItunsPod(pod: iTunsPod){
		self.updateItunsPod(pod: pod)
	}
	
	static public func updateItunsPod(pod: iTunsPod){
        var podcast = pod
		let exsitPod = self.getPodcast(feedUrl: pod.feedUrl)
        podcast.isNeedVpn = pod.feedUrl.contains("fireside") || pod.feedUrl.contains("feedburner")
		if exsitPod.isSome {
			try! self.database.update(table: exsitPodTable, on: iTunsPod.Properties.all, with: pod, where: iTunsPod.Properties.feedUrl == pod.feedUrl)
			return
		}
		try! self.database.insert(objects: pod, intoTable: exsitPodTable)
	}
		
	static public func deleteItunsPod(feedUrl: String){
		do{
			try self.database.delete(fromTable: exsitPodTable, where: iTunsPod.Properties.feedUrl == feedUrl)
		}
		catch{
			print(error)
		}
		
	}
	
	static public func deleteItunesPod(feedUrl: String){
		do{
			try self.database.delete(fromTable: exsitPodTable, where: iTunsPod.Properties.feedUrl == feedUrl)
		}
		catch{
			print(error)
		}
		
	}
}

// MARK: 进度记录操作
extension DatabaseManager {
	
    /// 查询进度记录
    static public func qureyProgress(trackUrl: String) -> Double{
        UserDefaults.standard.double(forKey: "Progress_" + trackUrl.trim())
    }

	
    /// 更新进度记录
	static public func updateProgress(progress: Double, trackUrl: String){
        UserDefaults.standard.set(progress, forKey: "Progress_" + trackUrl.trim())
		UserDefaults.standard.synchronize()
    }
	
}
