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

let chapterProvider = MoyaProvider<ChapterAPI>()

public enum ChapterAPI {
    case getHomeChapterList()
}

extension ChapterAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        var params:[String : Any] = [:]
//        params["pageNum"] = 1
//        params["pageSize"] = 15
        
        switch self {
            //        case .parserFeed(let rss):
            //            params["rss"] = rss
            //            break;
            //        case .getFeedItemList(let rss):
            //            params["rss"] = rss
        //            break;
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
        case .getHomeChapterList():
            return kGetHomeChapterListurl
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHomeChapterList():
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

