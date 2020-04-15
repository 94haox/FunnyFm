//
//  BCQResourceFragmentDownloader.swift
//  BCQMediaCache
//
//  Created by baochuquan on 2019/12/14.
//  Copyright © 2019 baochuquan. All rights reserved.
//

import Foundation
import AVFoundation

protocol BCQResourceFragmentDownloaderDelegate: class {
    func resourceFragmentDownloader(_ downloader: BCQResourceFragmentDownloader, didCompleteWithError error: Error?)
}

final class BCQResourceFragmentDownloader {
    weak var delegate: BCQResourceFragmentDownloaderDelegate?
    let url: URL
    let resourceInfo: BCQResourceInfo
    let originRequest: AVAssetResourceLoadingRequest            // 原始请求
    var customRequest: BCQResourceFragmentRequest?              // 自定义请求
    private let cacheEnable: Bool                               // 是否使用缓存功能

    deinit {
        cancel()
    }

    init(url: URL, resourceInfo: BCQResourceInfo, request: AVAssetResourceLoadingRequest, cacheEnable: Bool = true) {
        self.url = url
        self.resourceInfo = resourceInfo
        self.originRequest = request
        self.cacheEnable = cacheEnable
        fillContentInformationIfNeeded()        // 从本地读取时，必须设置 contentInformation
    }
}

// MARK: - Public Method
extension BCQResourceFragmentDownloader {
    func start() {
        guard let dataRequest = originRequest.dataRequest else { return }

        var offset = UInt64(dataRequest.requestedOffset)
        if dataRequest.currentOffset != 0 {
            offset = UInt64(dataRequest.currentOffset)
        }

        var length = UInt64(dataRequest.requestedLength)
        if dataRequest.requestsAllDataToEndOfResource, resourceInfo.meta.contentLength > offset {
            length = resourceInfo.meta.contentLength - offset
        }

        let range = BCQRange(offset: offset, length: length)
        let fragments = resourceInfo.fragments(with: range)
        let contents = fragments.map { "\($0.range)" }
        BCQResourceUtils.debugLog("origin request \(range) split into \(contents.count) fragment requests \(contents.joined(separator: ", "))")
        customRequest?.cancel()
        customRequest = BCQResourceFragmentRequest(url: url, resourceInfo: resourceInfo, fragments: fragments, cacheEnable: cacheEnable)
        customRequest?.delegate = self
        customRequest?.start()
    }

    func cancel() {
        if !originRequest.isFinished {
            originRequest.finishLoading(with: NSError(domain: "me.chuquan.bcqresource", code: -3, userInfo: [NSLocalizedDescriptionKey: "Resource Loader Cancelled"]))
        }
        customRequest?.cancel()
    }
}

// MARK: - BCQResourceFragmentRequestDelegate
extension BCQResourceFragmentDownloader: BCQResourceFragmentRequestDelegate {
    func resourceFragmentRequest(_ request: BCQResourceFragmentRequest, didReceive response: URLResponse) {
        fillContentInformationIfNeeded()
    }

    func resourceFragmentRequest(_ request: BCQResourceFragmentRequest, didReceive data: Data) {
        originRequest.dataRequest?.respond(with: data)
    }

    func resourceFragmentRequest(_ request: BCQResourceFragmentRequest, didCompleteWithError error: Error?) {
        if error?._code == NSURLErrorCancelled {
            return
        }

        if let error = error {
            originRequest.finishLoading(with: error)
        } else {
            originRequest.finishLoading()
        }
        delegate?.resourceFragmentDownloader(self, didCompleteWithError: error)
    }
}

// MAKR: - Utils
private extension BCQResourceFragmentDownloader {
    func fillContentInformationIfNeeded() {
        if let contentInformationRequest = originRequest.contentInformationRequest, contentInformationRequest.contentType == nil, !resourceInfo.meta.isEmpty {
            contentInformationRequest.contentType = resourceInfo.meta.contentType
            contentInformationRequest.contentLength = Int64(resourceInfo.meta.contentLength)
            contentInformationRequest.isByteRangeAccessSupported = resourceInfo.meta.byteRangeAccessSupported
        }
    }
}
