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
//        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let mp3Path = documentURL.appendingPathComponent("mp3")
//        let cache = Cache.init("funnyfm", downloadPath: nil, downloadTmpPath: nil, downloadFilePath: mp3Path.absoluteString)
//        self.sessionManager = SessionManager.init("funnyfm", configuration: SessionConfiguration(), logger: nil, cache: cache, operationQueue: DispatchQueue.init(label: "download"))
    }
	
	func beginDownload(_ episode: Episode) -> Bool{

        guard let task = sessionManager.download(episode.trackUrl) else {
            return false
        }

        task.success { (task) in
            if var episode = DatabaseManager.getEpisode(trackUrl: task.url.absoluteString) {
                episode.download_filpath = task.filePath
                DatabaseManager.add(download: episode)
                PlayListManager.shared.queueInsertAffter(episode: episode)
            }
            self.delegate?.didDownloadSuccess(fileUrl: task.filePath, sourceUrl: task.url.absoluteString)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.downloadSuccessNotification, object: ["sourceUrl": task.url.absoluteString])
            }
        }
        
        task.progress { (task) in
            let progress = Double(task.progress.completedUnitCount) / Double(task.progress.totalUnitCount)
            self.delegate?.downloadProgress(progress: progress, sourceUrl: task.url.absoluteString)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.downloadProgressNotification, object: ["progress":progress,"sourceUrl":task.url.absoluteString])
            }
        }
        
        task.failure { (task) in
            guard let episode = DatabaseManager.getEpisode(trackUrl: task.url.absoluteString) else {
                return
            }
            let tip = String.init(format: "%@%@",  episode.title, "下载失败".localized)
            self.delegate?.didDownloadFailure(sourceUrl: task.url.absoluteString)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.downloadFailureNotification, object: ["sourceUrl": task.url.absoluteString])
                
            }
            SwiftNotice.noticeOnStatusBar(tip, autoClear: true, autoClearTime: 1)
        }
        
		return true
	}
	
	func stopDownload(episode: Episode) {
        guard let url = URL.init(string: episode.trackUrl) else {
            return
        }
        sessionManager.cancel(url)
	}
	
}

