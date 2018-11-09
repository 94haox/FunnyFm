//
//  PodApi.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import Moya



let kGetPodListurl = "v1/podlist"



let apiProvider = MoyaProvider<PodAPI>()

public enum PodAPI {
    case getPodList()
}

extension PodAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        var params:[String : Any] = [:]
        
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
        case .getPodList():
            return kGetPodListurl
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPodList():
            return .get
//        default:
//            return .post
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
