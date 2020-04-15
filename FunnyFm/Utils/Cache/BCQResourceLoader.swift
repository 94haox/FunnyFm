//
//  BCQResourceLoader.swift
//  BCQMediaCache
//
//  Created by baochuquan on 2019/12/14.
//  Copyright © 2019 baochuquan. All rights reserved.
//

import Foundation
import AVFoundation

protocol BCQResourceLoaderDelegate: class {
    func resourceLoader(_ loader: BCQResourceLoader, didCompleteWithError error: Error?)
}

final class BCQResourceLoader {
    weak var delegate: BCQResourceLoaderDelegate?
    let url: URL
    let resourceInfo: BCQResourceInfo

    private var pendingDownloaders = [BCQResourceFragmentDownloader]()           // 边播边下载

    deinit {
        clearRequests()
    }

    init(url: URL) {
        BCQResourceUtils.debugLog("URL: \(url.absoluteString)")
        self.url = url
        self.resourceInfo = BCQResourceInfo(url: url)
    }
}

// MARK: - Public Download Method
extension BCQResourceLoader {
    func addRequest(_ request: AVAssetResourceLoadingRequest) {
        let downloader = BCQResourceFragmentDownloader(url: url, resourceInfo: resourceInfo, request: request)
        pendingDownloaders.append(downloader)
        downloader.delegate = self
        downloader.start()
    }

    func removeRequest(_ request: AVAssetResourceLoadingRequest) {
        let downloader = pendingDownloaders.enumerated().filter { $0.element.originRequest == request }
        downloader.forEach {
            $0.element.cancel()
            pendingDownloaders.remove(at: $0.offset)
        }
    }

    func clearRequests() {
        pendingDownloaders.forEach {
            $0.cancel()
        }
        pendingDownloaders.removeAll()
    }
}

// MARK: - BCQResourceFragmentDownloaderDelegate
extension BCQResourceLoader: BCQResourceFragmentDownloaderDelegate {
    func resourceFragmentDownloader(_ downloader: BCQResourceFragmentDownloader, didCompleteWithError error: Error?) {
        removeRequest(downloader.originRequest)
        delegate?.resourceLoader(self, didCompleteWithError: error)
    }
}
