//
//  ChapterAPI.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/6.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import Moya



let kGetHomeChapterListurl = "v1/homeChapterlist"
let kGetChapterListurl = "v1/chapterlist"

let chapterProvider = MoyaProvider<ChapterAPI>()

public enum ChapterAPI {
    case getHomeChapterList
    case getChapterList(Int,Int)
}

extension ChapterAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        var params:[String : Any] = [:]
        params["userId"] = UserCenter.shared.userId
        switch self {
        case .getChapterList(let pageNum,let albumId):
            params["pageNum"] = pageNum
            params["albumId"] = albumId
            break;
        default:
            break
            
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
    
    
    public var baseURL: URL {
        return URL.init(string: FunnyFm.baseurl)!;
    }
    
    public var path: String {
        switch self {
        case .getHomeChapterList:
            return kGetHomeChapterListurl
        case .getChapterList(_):
            return kGetChapterListurl
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHomeChapterList:
            return .get
        case .getChapterList(_):
            return .get
        }
        
    }
    
    public var headers: [String : String]? {
        var header: [String:String] = [:]
        header["os"] = "iOS"
        header["version"] = "0.1"
        header["Content-type"] = "application/json"
        return header
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    
}

