//
//  DownloadManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/3.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Alamofire
import Tiercel

protocol DownloadManagerDelegate {
	func downloadProgress(progress:Double, sourceUrl: String);
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String);
	func didDownloadFailure(sourceUrl: String);
	func didDownloadCancel(sourceUrl: String);
}

extension DownloadManagerDelegate {
	func downloadProgress(progress:Double, sourceUrl: String){}
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String){}
	func didDownloadFailure(sourceUrl: String){}
	func didDownloadCancel(sourceUrl: String){}
}



class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    
    var sessionManager = SessionManager("DownloadManager", configuration: SessionConfiguration())
	
	var delegate: DownloadManagerDelegate?
	
    var downloadQueue: [DownloadTask] {
        get {
            return sessionManager.tasks
        }
    }
	
    
    func configSession() {
        let documentURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let mp3Path = documentURL.appending("/mp3")
        let cachePath =  Cache.defaultDiskCachePathClosure("mp3")
        if !FileManager.default.fileExists(atPath: mp3Path) {
            try? FileManager.default.createDirectory(atPath: mp3Path, withIntermediateDirectories: true, attributes: nil)
        }
        let cache = Cache.init("funnyfm", downloadPath: cachePath, downloadFilePath: mp3Path)
        self.sessionManager = SessionManager.init("funnyfm", configuration: SessionConfiguration(), logger: nil, cache: cache, operationQueue: DispatchQueue.init(label: "download"))
    }
	
	func beginDownload(_ episode: Episode) -> Bool{

		guard let task = sessionManager.download(episode.trackUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return false
        }

        task.success { [weak self](task) in
			guard let url = task.url.absoluteString.removingPercentEncoding else {
				return
			}
            if var episode = DatabaseManager.getEpisode(trackUrl: url) {
                episode.download_filpath = task.filePath.components(separatedBy: "/").last!
                self?.sessionManager.remove(task)
                DatabaseManager.add(download: episode)
                PlayListManager.shared.queueInsertAffter(episode: episode)
            }
            self?.delegate?.didDownloadSuccess(fileUrl: task.filePath, sourceUrl: url)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.downloadSuccessNotification, object: ["sourceUrl": task.url.absoluteString])
            }
        }
        
        task.progress { (task) in
			guard let url = task.url.absoluteString.removingPercentEncoding else {
				return
			}
            let progress = Double(task.progress.completedUnitCount) / Double(task.progress.totalUnitCount)
            self.delegate?.downloadProgress(progress: progress, sourceUrl: url)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.downloadProgressNotification, object: ["progress":progress,"sourceUrl": url])
            }
        }
        
        task.failure { [weak self](task) in
			
			DispatchQueue.main.async {
				NotificationCenter.default.post(name: Notification.downloadChangeNotification, object: ["sourceUrl": task.url.absoluteString])
			}
			
			guard let url = task.url.absoluteString.removingPercentEncoding, task.status == .failed else {
				return
			}
			
            guard let episode = DatabaseManager.getEpisode(trackUrl: url) else {
                return
            }
            
            if let _ = DatabaseManager.qureyDownload(title: episode.title) {
                return
            }
            
            let tip = String.init(format: "%@%@",  episode.title, "下载失败".localized)
            self?.delegate?.didDownloadFailure(sourceUrl: url)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.downloadFailureNotification, object: ["sourceUrl": task.url.absoluteString])
                
            }
            SwiftNotice.noticeOnStatusBar(tip, autoClear: true, autoClearTime: 1)
            self?.sessionManager.remove(task)
        }
        
		return true
	}
	
	func stopDownload(episode: Episode) {
		guard let task = sessionManager.download(episode.trackUrl.removingPercentEncoding!) else {
			return
        }
		sessionManager.remove(task, completely: true)
	}
	
}

