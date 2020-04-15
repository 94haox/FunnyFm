//
//  BCQResourceFragment.swift
//  BCQMediaCache
//
//  Created by baochuquan on 2019/12/14.
//  Copyright © 2019 baochuquan. All rights reserved.
//

import Foundation

enum BCQResourceFragmentType {
    case local                          // 已缓存本地
    case remote                         // 未缓存本地
}

final class BCQRange: NSObject, NSCoding {
    let kBCQRangeOffsetKey = "kBCQRangeOffsetKey"
    let kBCQRangeLengthKey = "kBCQRangeLengthKey"

    let offset: UInt64                                  // 偏移
    let length: UInt64                                  // 长度

    var left: UInt64 { return offset }                  // 左端索引
    var right: UInt64 { return offset + length - 1 }    // 右端索引

    init(offset: UInt64, length: UInt64) {
        assert(length > 0, "length must larger than 0")
        self.offset = offset
        self.length = length
    }

    convenience init(left: UInt64, right: UInt64) {
        self.init(offset: left, length: right - left + 1)
    }

    func encode(with coder: NSCoder) {
        coder.encode(offset, forKey: kBCQRangeOffsetKey)
        coder.encode(length, forKey: kBCQRangeLengthKey)
    }

    init?(coder: NSCoder) {
        offset = coder.decodeObject(forKey: kBCQRangeOffsetKey) as? UInt64 ?? 0
        length = coder.decodeObject(forKey: kBCQRangeLengthKey) as? UInt64 ?? 0
    }

    override public var description: String {
        return "[\(left)-\(right)]"
    }

    // 取交集
    func intersection(_ range: BCQRange) -> BCQRange? {
        let (rangeA, rangeB) = left <= range.left ? (self, range) : (range, self)
        var intersectionRange: BCQRange? = nil
        if rangeA.right >= rangeB.left {
            intersectionRange = BCQRange(left: rangeB.left, right: min(rangeA.right, rangeB.right))
        }
        return intersectionRange
    }

    // 取并集
    func union(_ range: BCQRange) -> [BCQRange] {
        let (rangeA, rangeB) = left <= range.left ? (self, range) : (range, self)

        var unionRanges = [BCQRange]()
        if rangeA.right + 1 >= rangeB.left {
            unionRanges.append(BCQRange(left: rangeA.left, right: max(rangeA.right, rangeB.right)))
        } else {
            unionRanges = [rangeA, rangeB]
        }
        return unionRanges
    }

    // 根据 size 进行分割
    func split(with size: UInt64) -> [BCQRange] {
        let result = length.quotientAndRemainder(dividingBy: size)
        var ranges = [BCQRange]()
        var index = offset
        for _ in 0..<result.quotient {
            ranges.append(BCQRange(offset: index, length: size))
            index += size
        }
        if result.remainder > 0 {
            ranges.append(BCQRange(left: index, right: right))
        }
        return ranges
    }

    public static func ==(lhs: BCQRange, rhs: BCQRange) -> Bool {
        return lhs.offset == rhs.offset && lhs.length == rhs.length
    }
}

final class BCQResourceFragment {
    let type: BCQResourceFragmentType       // 数据分片类型
    let range: BCQRange                      // 数据分片范围

    init(type: BCQResourceFragmentType, range: BCQRange) {
        self.type = type
        self.range = range
    }
}

