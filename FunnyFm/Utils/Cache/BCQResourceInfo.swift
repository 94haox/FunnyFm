//
//  BCQResourceInfo.swift
//  BCQMediaCache
//
//  Created by baochuquan on 2019/12/14.
//  Copyright © 2019 baochuquan. All rights reserved.
//

import Foundation

enum BCQResourceInfoError: Error {
    case fileHandleError
    case noFileError
    case otherError
}

private extension UInt64 {
    static let localFragmentSizeLimit: UInt64 = 80 * 1024           // 从本地读取时，单个数据块的大小
}

final class BCQResourceInfo {
    let url: URL
    private var metaPath: String
    private var dataPath: String
    private(set) var meta: BCQResourceMeta

    private var writeFileHanlde: FileHandle?
    private var readFileHandle: FileHandle?
    private var readWriteQueue = OperationQueue()

    deinit {
        meta.updateTime = Date().timeIntervalSince1970
        _ = BCQResourceInfo.writeCacheMeta(with: meta, url: url)
        writeFileHanlde?.closeFile()
        readFileHandle?.closeFile()
    }

    init(url: URL) {
        self.url = url
        self.metaPath = BCQResourceUtils.cacheMetaPath(with: url)
        self.dataPath = BCQResourceUtils.cacheDataPath(with: url)
        self.readWriteQueue.maxConcurrentOperationCount = 1

        if let meta = BCQResourceInfo.readCacheMeta(with: url) {
            self.meta = meta
            BCQResourceUtils.debugLog("Init Meta From Disk: \(meta.cacheRanges.map { "\($0)" }.joined(separator: ", "))")
        } else {
            self.meta = BCQResourceMeta(url: url,
                                       contentType: "",
                                       contentLength: 0,
                                       byteRangeAccessSupported: false,
                                       cacheRanges: [])
            _ = BCQResourceInfo.writeCacheMeta(with: meta, url: url)
            BCQResourceUtils.debugLog("Init Meta From Null: \(meta.cacheRanges.map { "\($0)" }.joined(separator: ", "))")
        }
    }
}

// MARK: - Public CacheMeta Method
extension BCQResourceInfo {
    func updateMeta(with contentType: String) {
        meta.contentType = contentType
    }

    func updateMeta(with contentLength: UInt64) {
        guard meta.contentLength != contentLength else { return }
        meta.contentLength = contentLength
        // contentLength 发生变化时，重新创建指定长度的缓存文件
        _ = BCQResourceUtils.initCacheData(with: url, length: contentLength)
    }

    func updateMeta(with byteRangeAccessSupported: Bool) {
        meta.byteRangeAccessSupported = byteRangeAccessSupported
    }

    func fragments(with range: BCQRange) -> [BCQResourceFragment] {
        guard meta.cacheRanges.count > 0 else {
            return [BCQResourceFragment(type: .remote, range: range)]
        }

        var result: [BCQResourceFragment] = []
        var rightRange = range
        for cacheRange in meta.cacheRanges {
            if let intersectionRange = rightRange.intersection(cacheRange) {            // 有交集
                // 左边部分
                if rightRange.left < intersectionRange.left {
                    let remote = BCQResourceFragment(type: .remote, range: BCQRange(left: rightRange.left, right: intersectionRange.left - 1))
                    result.append(remote)
                }
                // 中间部分（重叠部分）
                let local = BCQResourceFragment(type: .local, range: intersectionRange)
                result.append(local)
                // 右边部分
                if rightRange.right > intersectionRange.right {
                    rightRange = BCQRange(left: intersectionRange.right + 1, right: rightRange.right)
                } else {
                    break
                }
            } else {
                if rightRange.right < cacheRange.left {
                    let remote = BCQResourceFragment(type: .remote, range: rightRange)
                    result.append(remote)
                    break
                }
            }
        }
        if meta.cacheRanges.last!.right < rightRange.left {
            let remote = BCQResourceFragment(type: .remote, range: rightRange)
            result.append(remote)
        }

        return splitOversizeLocalFragment(with: result)
    }

    class func localMetas() -> [BCQResourceMeta] {
        return BCQResourceUtils.cacheMetaPaths().compactMap {
            NSKeyedUnarchiver.unarchiveObject(withFile: $0) as? BCQResourceMeta
        }
    }
}

// MARK: - Private CacheMeta Methods
extension BCQResourceInfo {
    private class func readCacheMeta(with url: URL) -> BCQResourceMeta? {
        let path = BCQResourceUtils.cacheMetaPath(with: url)
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? BCQResourceMeta
    }

    private class func writeCacheMeta(with meta: BCQResourceMeta, url: URL) -> Bool {
        let path = BCQResourceUtils.cacheMetaPath(with: url)
        return NSKeyedArchiver.archiveRootObject(meta, toFile: path)
    }

    private func mergeCacheRangesForMeta(with range: BCQRange) {
        if meta.cacheRanges.isEmpty {
            meta.cacheRanges = [range]
        } else {
            var result: [BCQRange] = []
            var unionRange = range
            var unionRangeAppended = false

            for cacheRange in meta.cacheRanges {
                let unionRanges = cacheRange.union(unionRange)
                if unionRanges.count == 1 {
                    // 有交集，则合并
                    unionRange = unionRanges.first!
                } else {
                    // 无交集，则加入
                    if unionRanges.first! == unionRange, !unionRangeAppended {
                        result.append(unionRange)
                        result.append(cacheRange)
                        unionRangeAppended = true
                    } else {
                        result.append(cacheRange)
                    }
                }
            }
            if !unionRangeAppended {
                result.append(unionRange)
            }
            meta.cacheRanges = result

            let contents = result.map { "\($0)" }
            BCQResourceUtils.debugLog("CacheRanges updated to " + contents.joined(separator: ","))
        }
    }

    private func splitOversizeLocalFragment(with fragments: [BCQResourceFragment]) -> [BCQResourceFragment] {
        var result = [BCQResourceFragment]()
        for fragment in fragments {
            if fragment.type == .local {
                result += fragment.range.split(with: .localFragmentSizeLimit).map { BCQResourceFragment(type: .local, range: $0) }
            } else {
                result.append(fragment)
            }
        }
        return result
    }
}

// MARK: - Public CacheData Method
extension BCQResourceInfo {
    func readCacheData(with range: BCQRange, complete: @escaping(_ result: Result<Data, BCQResourceInfoError>) -> ()) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else {
                complete(.failure(.otherError))
                return
            }
            if self.readFileHandle == nil {
                self.readFileHandle = FileHandle(forReadingAtPath: self.dataPath)
            }
            guard let readFileHandle = self.readFileHandle else {
                complete(.failure(.fileHandleError))
                return
            }
            readFileHandle.seek(toFileOffset: range.offset)
            let data = readFileHandle.readData(ofLength: Int(range.length))
            complete(.success(data))
        }
        operation.queuePriority = .high
        readWriteQueue.addOperation(operation)
    }

    func writeCacheData(_ data: Data, range: BCQRange, complete: @escaping(_ result: Result<Data, BCQResourceInfoError>) -> ()) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else {
                complete(.failure(.otherError))
                return
            }
            if self.writeFileHanlde == nil {
                self.writeFileHanlde = FileHandle(forWritingAtPath: self.dataPath)
            }
            guard let writefileHandle = self.writeFileHanlde else {
                complete(.failure(.fileHandleError))
                return
            }
            writefileHandle.seek(toFileOffset: range.offset)
            writefileHandle.write(data)
            self.mergeCacheRangesForMeta(with: range)
            complete(.success(data))
        }
        operation.queuePriority = .normal
        readWriteQueue.addOperation(operation)
    }
}

