//
//  DownloadTask.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/12.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import Alamofire


protocol DownloadTaskDelegate {
	func downloadProgress(progress:Double, sourceUrl: String);
	func didDownloadSuccess(fileUrl: String?, sourceUrl: String);
	func didDownloadFailure(sourceUrl: String);
}

class DownloadTask : NSObject{
	
	var downloadRequest: DownloadRequest!
	var cancelledData: Data?
	var delegate: DownloadTaskDelegate?
	var episode: Episode?
	var sourceUrl: String = ""
	var addDate: String = ""
	
	init(url:String) {
		super.init()
		self.sourceUrl = url
		self.addDate = Date.init().dateString()
        
	}
	
	init(episode: Episode) {
		super.init()
		self.episode = episode
		self.sourceUrl = self.episode!.trackUrl
		self.addDate = Date.init().dateString()
	}
	
	let destination: DownloadRequest.Destination = { url, response in
		let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let mp3Path = documentURL.appendingPathComponent("mp3")
		let fileURL = mp3Path.appendingPathComponent(response.suggestedFilename!)
		return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
	}
	
	func downloadProgress(progress:Progress){
		self.delegate?.downloadProgress(progress: Double(progress.fractionCompleted), sourceUrl: self.sourceUrl)
	}
	
	func beginDownload(){
		if self.downloadRequest.isSome {
			if self.downloadRequest!.request.isSome {
				if self.downloadRequest.request!.url!.absoluteString == self.sourceUrl {
					return;
				}
			}
		}
		if let cancelledData = self.cancelledData {
			//续传
            self.downloadRequest = Session.default.download(resumingWith: cancelledData, to: self.destination)
			self.downloadRequest.downloadProgress(closure: downloadProgress)
			self.downloadRequest.responseData(completionHandler: downloadResponse)
		}else{
			//开始下载
            self.downloadRequest = Session.default.download(self.sourceUrl, to: self.destination)
			self.downloadRequest.downloadProgress(closure: downloadProgress)
			self.downloadRequest.responseData(completionHandler: downloadResponse)
            
		}
		
		
	}
	
	func stopDownload(){
		self.downloadRequest.cancel()
	}
	
	
	func downloadResponse(response: AFDownloadResponse<Data>){
		switch response.result {
		case .success(_):
			self.delegate?.didDownloadSuccess(fileUrl: response.fileURL?.path, sourceUrl: self.sourceUrl)
            break
		case .failure(let error):
            print(error.localizedDescription)
			self.cancelledData = response.resumeData //意外中止的话把已下载的数据存起来
			self.delegate?.didDownloadFailure(sourceUrl: self.sourceUrl)
			break
		}
	}
	
}
