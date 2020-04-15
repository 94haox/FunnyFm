//
//  BCQResourceUtils.swift
//  BCQMediaCache
//
//  Created by baochuquan on 2019/12/14.
//  Copyright © 2019 baochuquan. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

final class BCQResourceUtils: NSObject {
    
    static let shared = BCQResourceUtils.init()
    
    func getAllCacheSize() -> UInt64 {
        let cacheSize = self.getCacheSize(cachePath: BCQResourceUtils.cacheFolder())
        let metaSize = self.getCacheSize(cachePath: BCQResourceUtils.metaFolder())
        return cacheSize + metaSize
    }
    
    func cleanAllCache() {
        self.remove(cachePath: BCQResourceUtils.cacheFolder())
        self.remove(cachePath: BCQResourceUtils.metaFolder())
    }
    
    private func remove(cachePath: String) {
        let fileManager = FileManager.default
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: cachePath)
            for path in filePaths {
                let filepath = "\(cachePath)/\(path)"
                try? fileManager.removeItem(atPath: filepath)
            }
        }catch{}
    }
    
    private func getCacheSize(cachePath: String) -> UInt64 {
        let fileManager = FileManager.default
        var fileSize: UInt64 = 0
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: cachePath)
            for path in filePaths {
                let filepath = "\(cachePath)/\(path)"
                let attrs = try? fileManager.attributesOfItem(atPath: filepath)
                if attrs.isSome {
                    let size = attrs![FileAttributeKey.size] as! UInt64
                    fileSize += size
                }
            }
        }catch{}
        return UInt64(fileSize)
    }
    
    private class func cacheFolder() -> String {
        let fileManager = FileManager.default
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
        assert(!path.isEmpty, "Cache directory should not be nil")
        path = path.appending("/bcqresource/data")
        if !fileManager.fileExists(atPath: path) {
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }

    private class func metaFolder() -> String {
        let fileManager = FileManager.default
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
        assert(!path.isEmpty, "Cache directory should not be nil")
        path = path.appending("/bcqresource/meta")
        if !fileManager.fileExists(atPath: path) {
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }

    private class func thumbnailFolder() -> String {
        let fileManager = FileManager.default
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
        assert(!path.isEmpty, "Cache directory should not be nil")
        path = path.appending("/bcqresource/thumbnail")
        if !fileManager.fileExists(atPath: path) {
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}

// MARK: - Public Method
extension BCQResourceUtils {
    class func cacheDataPath(with url: URL) -> String {
        return cacheFolder() + "/" + url.absoluteString.md5()
    }

    class func cacheMetaPath(with url: URL) -> String {
        return metaFolder() + "/" + url.absoluteString.md5()
    }

    class func cacheThumbnailPath(with url: URL) -> String {
        return thumbnailFolder() + "/" + url.absoluteString.md5()
    }

    class func initCacheData(with url: URL, length: UInt64) -> Bool {
        let path = cacheDataPath(with: url)
        if FileManager.default.fileExists(atPath: path) {
            guard let _ = try? FileManager.default.removeItem(atPath: path) else {
                return false
            }
        }
        return FileManager.default.createFile(atPath: path, contents: Data(capacity: Int(length)), attributes: nil)
    }

    class func cacheMetaPaths() -> [String] {
        let metaFolderPath = metaFolder()
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: metaFolderPath) else { return [] }
        return fileNames.map {
            metaFolderPath + "/" + $0
        }
    }

    class func removeCache(with url: URL) {
        let metaPath = cacheMetaPath(with: url)
        let dataPath = cacheDataPath(with: url)
        let thumbnailPath = cacheThumbnailPath(with: url)
        try? FileManager.default.removeItem(atPath: metaPath)
        try? FileManager.default.removeItem(atPath: dataPath)
        try? FileManager.default.removeItem(atPath: thumbnailPath)
    }

    class func debugLog(_ content: String) {
        let event = "FFResource: \(content)"
        #if DEBUG
            print(event)
        #endif
    }

    class func writeThumbnail(with thumbnail: UIImage, url: URL) -> Bool {
        guard let data = thumbnail.pngData() else { return false }
        let fileURL = URL(fileURLWithPath: cacheThumbnailPath(with: url))
        do {
            try data.write(to: fileURL, options: .atomic)
            return true
        } catch {
            return false
        }
    }

    class func readThumbnail(with url: URL) -> UIImage? {
        let path = cacheThumbnailPath(with: url)
        if FileManager.default.fileExists(atPath: path) {
            let image = UIImage(contentsOfFile: path)
            return image
        }
        return nil
    }

    class func createThumbnailForLocalVideo(with url: URL) -> UIImage? {
        let path = cacheDataPath(with: url)
        let fileURL = URL(fileURLWithPath: path)
        let asset = AVAsset(url: fileURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        var time = asset.duration
        time.value = 0
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }

    class func createThumbnailForRemoteVideo(with url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        var time = asset.duration
        time.value = 0
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
}
