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
    func downloadProgress();
    func didDownloadSuccess() -> NSURL;
    func didDownloadFailure();
}



class DownloadManager: NSObject {
    
    let shared = DownloadManager.init()
    var downloadRequest:DownloadRequest!
    var cancelledData:Data?
    let delegate: DownloadManagerDelegate?
    
    let destination:DownloadRequest.DownloadFileDestination = { url, response in
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let mp3Path = documentURL.appendingPathComponent("mp3")
        let fileURL = mp3Path.appendingPathComponent(response.suggestedFilename!)
        return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
    }
    
    func downloadProgress(progress:Progress){
//        self.progress.setProgress(Float(progress.fractionCompleted), animated: true)
        print("当前进度:\(progress.fractionCompleted*100)%")
    }
    
    func beginDownload(_ url: String){
        if let cancelledData = self.cancelledData {
            //续传
            self.downloadRequest = Alamofire.download(resumingWith: cancelledData, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
        }else{
            //开始下载
            self.downloadRequest = Alamofire.download(url, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
        }
    }
    
    
    func downloadResponse(response:DownloadResponse<Data>){
        switch response.result {
        case .success(_):
            //下载完成
            print("路径:\(response.destinationURL?.path)")
        case .failure(error:):
            self.cancelledData = response.resumeData //意外中止的话把已下载的数据存起来
            break
        }
    }
}
