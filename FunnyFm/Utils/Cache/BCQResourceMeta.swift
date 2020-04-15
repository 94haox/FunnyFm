//
//  BCQResourceMeta.swift
//  BCQMediaCache
//
//  Created by baochuquan on 2019/12/14.
//  Copyright © 2019 baochuquan. All rights reserved.
//

import Foundation

final class BCQResourceMeta: NSObject, NSCoding {
    private let kResourceMetaUrlKey                         = "kResourceMetaUrlKey"
    private let kResourceMetaContentTypeKey                 = "kResourceMetaContentTypeKey"
    private let kResourceMetaContentLengthKey               = "kResourceMetaContentLengthKey"
    private let kResourceMetaByteRangeAccessSupportedKey    = "kResourceMetaByteRangeAccessSupportedKey"
    private let kResourceMetaCacheRangesKey                 = "kResourceInfoCacheRangesKey"
    private let kResourceMetaUpdateTimeKey                  = "kResourceMetaUpdateTime"

    var url: URL
    var contentType: String = ""
    var contentLength: UInt64 = 0
    var byteRangeAccessSupported: Bool = false
    var cacheRanges: [BCQRange] = []
    var isEmpty: Bool {
        return contentLength == 0
    }
    var updateTime: TimeInterval

    var downloadedContentLength: UInt64 {
        return cacheRanges.reduce(0, { $0 + $1.length })
    }

    init(url: URL,
         contentType: String,
         contentLength: UInt64,
         byteRangeAccessSupported: Bool,
         cacheRanges: [BCQRange] = [])
    {
        self.url = url
        self.contentType = contentType
        self.contentLength = contentLength
        self.byteRangeAccessSupported = byteRangeAccessSupported
        self.cacheRanges = cacheRanges
        self.updateTime = Date().timeIntervalSince1970
    }

    init?(coder: NSCoder) {
        url = coder.decodeObject(forKey: kResourceMetaUrlKey) as? URL ?? URL(string: "https://chuquan.me")!
        contentType = coder.decodeObject(forKey: kResourceMetaContentTypeKey) as? String ?? ""
        contentLength = coder.decodeObject(forKey: kResourceMetaContentLengthKey) as? UInt64 ?? 0
        byteRangeAccessSupported = coder.decodeBool(forKey: kResourceMetaByteRangeAccessSupportedKey)
        cacheRanges = coder.decodeObject(forKey: kResourceMetaCacheRangesKey) as? [BCQRange] ?? []
        updateTime = coder.decodeDouble(forKey: kResourceMetaUpdateTimeKey)
    }

    func encode(with coder: NSCoder) {
        coder.encode(url, forKey: kResourceMetaUrlKey)
        coder.encode(contentType, forKey: kResourceMetaContentTypeKey)
        coder.encode(contentLength, forKey: kResourceMetaContentLengthKey)
        coder.encode(byteRangeAccessSupported, forKey: kResourceMetaByteRangeAccessSupportedKey)
        coder.encode(cacheRanges, forKey: kResourceMetaCacheRangesKey)
        coder.encode(updateTime, forKey: kResourceMetaUpdateTimeKey)
    }
}

extension BCQResourceMeta {
    func isAllDownloaded() -> Bool {
        guard contentLength != 0 else { return false }
        return contentLength == downloadedContentLength
    }
}

