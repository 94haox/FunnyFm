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
	
	var downloadQueue = [String:Any]()
	
	func beginDownload(_ episode: Episode){
		if let _ = downloadQueue[episode.trackUrl] {
			return
		}
		let task = DownloadTask.init(url: episode.trackUrl)
		task.beginDownload()
		task.delegate = self
		self.downloadQueue[episode.trackUrl] = task
	}
}


extension DownloadManager : DownloadTaskDelegate {
	
	func downloadProgress(progress: Double, sourceUrl: String) {
		self.delegate?.downloadProgress(progress: progress, sourceUrl: sourceUrl)
	}
	
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String) {
		self.downloadQueue.removeValue(forKey: sourceUrl)
		self.delegate?.didDownloadSuccess(fileUrl: fileUrl, sourceUrl: sourceUrl)
	}
	
	func didDownloadFailure(sourceUrl: String) {
		self.downloadQueue.removeValue(forKey: sourceUrl)
		self.delegate?.didDownloadFailure(sourceUrl: sourceUrl)
	}
	
}
