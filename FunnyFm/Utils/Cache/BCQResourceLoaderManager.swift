//
//  BCQResourceLoaderManager.swift
//  BCQMediaCache
//
//  Created by baochuquan on 2019/12/14.
//  Copyright © 2019 baochuquan. All rights reserved.
//

import Foundation
import AVFoundation

protocol BCQResourceLoaderManagerDelegate: class {
    func resourceLoaderManager(_ manager: BCQResourceLoaderManager, didCompleteWithError error: Error?)
}

final class BCQResourceLoaderManager: NSObject {
    static let urlScheme = "bcqresource:"                   // 手动实现 AVAssetResourceLoaderDelegate 协议需要 URL 是自定义的 URLScheme

    weak var delegate: BCQResourceLoaderManagerDelegate?
    var loaders = [String : BCQResourceLoader]()            // key: URL.absoluteString
}

// MAKR: - Public Methods
extension BCQResourceLoaderManager {
    class func assetURL(_ url: URL?) -> URL? {
        guard let url = url else { return nil }
        let assetURL = URL(string: urlScheme + url.absoluteString)
        return assetURL
    }

    func asset(with url: URL?) -> AVURLAsset? {
        guard let assetURL = BCQResourceLoaderManager.assetURL(url) else { return nil }
        return AVURLAsset(url: assetURL, options: nil)
    }

    func playerItem(with url: URL?) -> AVPlayerItem? {
        guard let urlAsset = asset(with: url) else { return nil }
        urlAsset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        let playerItem = AVPlayerItem(asset: urlAsset)
        return playerItem
    }
}

// MARK: - AVAssetResourceLoaderDelegate
extension BCQResourceLoaderManager: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let resourceURL = loadingRequest.request.url else { return false }
        if resourceURL.absoluteString.hasPrefix(BCQResourceLoaderManager.urlScheme) {
            var loader = loaderForRequest(loadingRequest)
            if loader == nil, let originURL = URL(string: resourceURL.absoluteString.replacingOccurrences(of: BCQResourceLoaderManager.urlScheme, with: "")) {
                // 根据特定 URL 初始化一个 loader
                loader = BCQResourceLoader(url: originURL)
                loader?.delegate = self
                if let key = keyForLoader(with: resourceURL) {
                    loaders[key] = loader
                }
            }
            BCQResourceUtils.debugLog("addRequest")
            loader?.addRequest(loadingRequest)
            return true
        }
        return false
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        let loader = loaderForRequest(loadingRequest)
        BCQResourceUtils.debugLog("removeRequest")
        loader?.removeRequest(loadingRequest)
    }
}

// MARK: - BCQResourceLoaderDelegate
extension BCQResourceLoaderManager: BCQResourceLoaderDelegate {
    func resourceLoader(_ loader: BCQResourceLoader, didCompleteWithError error: Error?) {
        BCQResourceUtils.debugLog("requestComplete")
        if let _ = error {
            loader.clearRequests()
        }
        delegate?.resourceLoaderManager(self, didCompleteWithError: error)
    }
}

// MARK: - Utils
private extension BCQResourceLoaderManager {
    func keyForLoader(with url: URL?) -> String? {
        guard let url = url else { return nil }
        if url.absoluteString.hasPrefix(BCQResourceLoaderManager.urlScheme) {
            return url.absoluteString
        }
        return nil
    }

    func loaderForRequest(_ request: AVAssetResourceLoadingRequest) -> BCQResourceLoader? {
        guard let key = keyForLoader(with: request.request.url) else { return nil }
        return loaders[key]
    }

    // TODO:
    func clearCache() {
        let flagTime = Date(timeInterval: -(24*60*60)*5, since: Date()).timeIntervalSince1970 //5天
        let flagLength: UInt64 = (1024*1024*8)*500 //500MB
        let flagAlpha: Float = 0.7

        // 按照时间清理第一遍
        BCQResourceInfo.localMetas().filter({
            !loaders.keys.contains($0.url.absoluteString) && $0.updateTime < flagTime
        }).forEach {
            BCQResourceUtils.removeCache(with: $0.url)
        }

        // 按照空间清理第二遍
        let localMetas = BCQResourceInfo.localMetas().filter {
            !loaders.keys.contains($0.url.absoluteString)
        }
        let localLength = localMetas.reduce(0, {
            return $0 + $1.contentLength
        })
        if localLength > flagLength {
            for (index, element) in localMetas.enumerated() {
                if index < Int(Float(localMetas.count) * flagAlpha) {
                    BCQResourceUtils.removeCache(with: element.url)
                }
            }
        }
    }
}
