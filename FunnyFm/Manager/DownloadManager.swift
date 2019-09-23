//
//  DownloadManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/3.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Alamofire

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
	
	var delegate: DownloadManagerDelegate?
	
	var downloadQueue = [DownloadTask]()
	
	var downloadKeys = [String]()
	
	func beginDownload(_ episode: Episode) -> Bool{
		if downloadKeys.contains(episode.trackUrl) {
			return false
		}
		let task = DownloadTask.init(episode: episode)
		task.beginDownload()
		task.delegate = self
		self.downloadQueue.append(task)
		self.downloadKeys.append(episode.trackUrl)
		return true
	}
	
	func stopDownload(episode: Episode) {
		let index = self.downloadKeys.index(of: episode.trackUrl)
		if index.isSome {
			let task = self.downloadQueue[index!]
			self.stopDownload(task)
		}
	}
	
	func stopDownload(_ task: DownloadTask) {
		task.stopDownload()
		let index = self.downloadKeys.index(of: task.episode!.trackUrl)
		if index.isSome {
			self.downloadQueue.remove(at: index!)
			self.downloadKeys.remove(at: index!)
		}
		self.delegate?.didDownloadCancel(sourceUrl: task.episode!.trackUrl)
	}
	
}


extension DownloadManager : DownloadTaskDelegate {
	
	func downloadProgress(progress: Double, sourceUrl: String) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: Notification.downloadProgressNotification, object: ["progress":progress,"sourceUrl":sourceUrl])
		}
		self.delegate?.downloadProgress(progress: progress, sourceUrl: sourceUrl)

	}
	
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String) {
		let index = self.downloadKeys.index(of: sourceUrl)
		if index.isSome {
			let task = self.downloadQueue[index!]
			task.episode!.download_filpath = (fileUrl?.components(separatedBy: "/").last)!
			task.episode!.downloadSize = "\(ceil(Double(fileUrl!.getFileSize()) / 1000.0/1000))M"
			DatabaseManager.add(download: task.episode!)
			self.downloadQueue.remove(at: index!)
			self.downloadKeys.remove(at: index!)
		}
		
		if fileUrl.isNone{
			self.didDownloadFailure(sourceUrl: sourceUrl)
			return;
		}
		
		self.delegate?.didDownloadSuccess(fileUrl: fileUrl, sourceUrl: sourceUrl)
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: Notification.downloadSuccessNotification, object: ["sourceUrl": sourceUrl])
		}

		
		
	}
	
	func didDownloadFailure(sourceUrl: String) {
		let index = self.downloadKeys.index(of: sourceUrl)
		if index.isSome {
			let task = self.downloadQueue[index!]
			self.downloadQueue.remove(at: index!)
			self.downloadKeys.remove(at: index!)
			DispatchQueue.main.async {
				let tip = String.init(format: "%@%@",  task.episode!.title, "下载失败".localized)
				SwiftNotice.noticeOnStatusBar(tip, autoClear: true, autoClearTime: 1)
			}
		}

		self.delegate?.didDownloadFailure(sourceUrl: sourceUrl)
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: Notification.downloadFailureNotification, object: ["sourceUrl": sourceUrl])
			
		}
	}
	
}
