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
}



class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
	
	var delegate: DownloadManagerDelegate?
	
	var downloadQueue = [DownloadTask]()
	
	var downloadKeys = [String]()
	
	func beginDownload(_ episode: Episode){
		if downloadKeys.contains(episode.trackUrl) {
			return
		}
		let task = DownloadTask.init(episode: episode)
		task.beginDownload()
		task.delegate = self
		self.downloadQueue.append(task)
		self.downloadKeys.append(episode.trackUrl)
	}
}


extension DownloadManager : DownloadTaskDelegate {
	
	func downloadProgress(progress: Double, sourceUrl: String) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: NSNotification.Name.init("downloadprogress"), object: ["progress":progress,"sourceUrl":sourceUrl])
		}
		self.delegate?.downloadProgress(progress: progress, sourceUrl: sourceUrl)

	}
	
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String) {
		let index = self.downloadKeys.index(of: sourceUrl)
		if index.isSome {
			self.downloadQueue.remove(at: index!)
			self.downloadKeys.remove(at: index!)
		}
		self.delegate?.didDownloadSuccess(fileUrl: fileUrl, sourceUrl: sourceUrl)
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: NSNotification.Name.init("download_success_\(sourceUrl)"), object: nil)
		}
	}
	
	func didDownloadFailure(sourceUrl: String) {
		let index = self.downloadKeys.index(of: sourceUrl)
		if index.isSome {
			self.downloadQueue.remove(at: index!)
			self.downloadKeys.remove(at: index!)
		}

		self.delegate?.didDownloadFailure(sourceUrl: sourceUrl)
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: NSNotification.Name.init("download_failure_\(sourceUrl)"), object: nil)
		}
	}
	
}
