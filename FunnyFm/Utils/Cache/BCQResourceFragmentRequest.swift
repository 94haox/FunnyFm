//
//  BCQResourceFragmentRequest.swift
//  BCQMediaCache
//
//  Created by baochuquan on 2019/12/14.
//  Copyright © 2019 baochuquan. All rights reserved.
//

import Foundation
import MobileCoreServices

protocol BCQResourceFragmentRequestDelegate: class {
    func resourceFragmentRequest(_ request: BCQResourceFragmentRequest, didReceive response: URLResponse)
    func resourceFragmentRequest(_ request: BCQResourceFragmentRequest, didReceive data: Data)
    func resourceFragmentRequest(_ request: BCQResourceFragmentRequest, didCompleteWithError error: Error?)
}

private extension Int {
    static let bufferDataSizeLimit: Int = 80 * 1024         // 从远端读取时，缓存一段数据后写入磁盘
}

final class BCQResourceFragmentRequest: NSObject {
    weak var delegate: BCQResourceFragmentRequestDelegate?
    let url: URL
    let resourceInfo: BCQResourceInfo

    private let operationQueue = OperationQueue()
    private lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: operationQueue)
    }()
    private var task: URLSessionDataTask?
    private var bufferData: Data = Data()

    private var fragmentsOfRange = [BCQResourceFragment]()       // 数据分片对应的 fragments。对于 remote 类型的 fragment，需要发起网络请求；对于 local 类型的 fragment，只需从本地读取。
    private var currentFragment: BCQResourceFragment?            // 当前请求对应的 fragment

    private var isCancelled: Bool = false
    private var cacheEnable: Bool = true

    deinit {
        cancel()
    }

    init(url: URL, resourceInfo: BCQResourceInfo, fragments: [BCQResourceFragment], cacheEnable: Bool = true) {
        self.url = url
        self.resourceInfo = resourceInfo
        self.fragmentsOfRange = fragments
        self.cacheEnable = cacheEnable
        self.operationQueue.maxConcurrentOperationCount = 1
    }
}

// MARK: - Public Method
extension BCQResourceFragmentRequest {
    func start() {
        requestFragmentData()
    }

    func cancel() {
        isCancelled = true
        session.invalidateAndCancel()
    }
}

// MARK: - Private Methods
private extension BCQResourceFragmentRequest {
    func requestFragmentData() {
        guard !isCancelled else { return }
        guard fragmentsOfRange.count > 0 else { return }

        currentFragment = fragmentsOfRange.first
        updateCurrentFragmentForRange0to1IfNeeded()
        guard let currentFragment = currentFragment else {
            self.delegate?.resourceFragmentRequest(self, didCompleteWithError: nil)
            return
        }
        fragmentsOfRange.removeFirst()

        if currentFragment.type == .local, cacheEnable {
            BCQResourceUtils.debugLog("\(operationQueue.description) request fragment data\(currentFragment.range) from local")
            // fragment 类型为 local 则从本地读取
            resourceInfo.readCacheData(with: currentFragment.range) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    BCQResourceUtils.debugLog("Read range\(currentFragment.range) success")
                    self.delegate?.resourceFragmentRequest(self, didReceive: data)
                    if self.fragmentsOfRange.count == 0 {
                        self.delegate?.resourceFragmentRequest(self, didCompleteWithError: nil)
                    }
                case .failure(_):
                    BCQResourceUtils.debugLog("Read range\(currentFragment.range) failure")
                    // 本地读取失败，则转换成 remote，发起网络请求
                    let transformedFragment = BCQResourceFragment(type: .remote, range: currentFragment.range)
                    self.fragmentsOfRange.insert(transformedFragment, at: 0)
                }
                // 继续处理下一个 fragment 的请求
                self.requestFragmentData()
            }
        } else {
            BCQResourceUtils.debugLog("\(operationQueue.description) request fragment data\(currentFragment.range) from remote")
            // fragment 类型为 remote 则从远端读取
            let left = currentFragment.range.left
            let right = currentFragment.range.right
            let length = currentFragment.range.length
            let range = length >= Int.max ? "bytes=\(left)-" : "bytes=\(left)-\(right)"

            var request = URLRequest(url: url)
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            request.setValue(range, forHTTPHeaderField: "Range")
            task = session.dataTask(with: request)
            task?.resume()
        }
    }
}

// MARK: - URLSessionDataDelegate & URLSessionDelegate
extension BCQResourceFragmentRequest: URLSessionDataDelegate, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust, challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: trust)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let mimeType = response.mimeType, mimeType.contains("video/") || mimeType.contains("audio/") || mimeType.contains("application") {
            // 只处理 video/audio 资源
            cacheMetaData(with: response)
            delegate?.resourceFragmentRequest(self, didReceive: response)
            completionHandler(URLSession.ResponseDisposition.allow)
        } else {
            completionHandler(URLSession.ResponseDisposition.cancel)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard !isCancelled else { return }
        bufferData.append(data)
        if bufferData.count >= .bufferDataSizeLimit {
            saveBufferData()
        }
        delegate?.resourceFragmentRequest(self, didReceive: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        saveBufferData()

        if fragmentsOfRange.count == 0 {
            delegate?.resourceFragmentRequest(self, didCompleteWithError: error)
        } else {
            requestFragmentData()
        }
    }
}

// MARK: - Utils
private extension BCQResourceFragmentRequest {
    func cacheMetaData(with response: URLResponse) {
        var byteRangeAccessSupported = false
        var contentLength: UInt64 = 0
        var contentType = ""

        if let httpResponse = response as? HTTPURLResponse {
            let acceptRange = httpResponse.allHeaderFields["Accept-Ranges"] as? String ?? ""
            byteRangeAccessSupported = acceptRange == "bytes"
            // NOTE: Swift HTTPURLResponse 的天坑。
            // 正常情况下或者连接 Charles 并且 Disable SSL Proxying 情况下，Content-Range 为小写，即 content-type
            // 连接 Charles 并且 Enable SSL Proxying 情况下，Content-Range 为大写，即 Content-Range。
            let contentRange = httpResponse.allHeaderFields["content-range"] as? String ??
                               httpResponse.allHeaderFields["Content-Range"] as? String ?? ""
            if let substring = contentRange.components(separatedBy: "/").last, let length = UInt64(String(substring)) {
                contentLength = length
            } else {
                contentLength = UInt64(httpResponse.expectedContentLength)
            }
        }
        if let mimeType = response.mimeType, let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil) {
            contentType = UTI.takeRetainedValue() as String
        }

        self.resourceInfo.updateMeta(with: byteRangeAccessSupported)
        self.resourceInfo.updateMeta(with: contentLength)
        self.resourceInfo.updateMeta(with: contentType)
    }

    func saveBufferData() {
        if let currentFragment = currentFragment, bufferData.count > 0, cacheEnable {
            let data = bufferData
            let range = BCQRange(offset: currentFragment.range.offset, length: UInt64(data.count))
            resourceInfo.writeCacheData(data, range: range) { (result) in
                switch result {
                case .success(_):
                    BCQResourceUtils.debugLog("Write range\(range) success")
                case .failure(_):
                    BCQResourceUtils.debugLog("Write range\(range) failure")
                }
            }
            // 一个分片请求的会产生多个数据响应，因此需要不断更新 currentFragment 的 offset
            let offset = currentFragment.range.offset + UInt64(data.count)
            let length = currentFragment.range.length
            self.currentFragment = BCQResourceFragment(type: currentFragment.type, range: BCQRange(offset: offset, length: length))
            // 清空 buffer
            bufferData = Data()
        }
    }

    func updateCurrentFragmentForRange0to1IfNeeded() {
        guard let currentFragment = currentFragment else { return }
        guard currentFragment.type == .local, currentFragment.range.left == 0, currentFragment.range.right == 1 else { return }
        // 判断网络是否可用。如果网络可用，range[0-1]应该始终使用发起网络请求，以对应URL不变，视频变化的情况。
        // guard isNetworkExist else { return }
        let transformedFragment = BCQResourceFragment(type: .remote, range: currentFragment.range)
        self.currentFragment = transformedFragment
    }
}

