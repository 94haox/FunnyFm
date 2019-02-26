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
	func downloadProgress(progress:Double);
	func didDownloadSuccess(fileUrl: String?);
    func didDownloadFailure();
}



class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    var downloadRequest:DownloadRequest!
    var cancelledData:Data?
	var delegate: DownloadManagerDelegate?
	
    
    let destination:DownloadRequest.DownloadFileDestination = { url, response in
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let mp3Path = documentURL.appendingPathComponent("mp3")
        let fileURL = mp3Path.appendingPathComponent(response.suggestedFilename!)
        return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
    }
    
    func downloadProgress(progress:Progress){
		self.delegate?.downloadProgress(progress: Double(progress.fractionCompleted))
    }
    
    func beginDownload(_ episode: Episode){
        if let cancelledData = self.cancelledData {
            //续传
            self.downloadRequest = Alamofire.download(resumingWith: cancelledData, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
        }else{
            //开始下载
            self.downloadRequest = Alamofire.download(episode.trackUrl_high, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
        }
    }
    
    
    func downloadResponse(response:DownloadResponse<Data>){
        switch response.result {
        case .success(_):
			self.delegate?.didDownloadSuccess(fileUrl: response.destinationURL?.path)
        case .failure(error:):
            self.cancelledData = response.resumeData //意外中止的话把已下载的数据存起来
			self.delegate?.didDownloadFailure()
            break
        }
    }
}
