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
let kCheckPodSourceUrl = "v1/checkPodSource"
let kAddPodSourceUrl = "v1/addPodSource"



let apiProvider = MoyaProvider<PodAPI>()

public enum PodAPI {
    case getPodList()
	case checkPodSource(String, String)
	case addPodSource(String, String, String)
}

extension PodAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        var params:[String : Any] = [:]
		switch self {
		case .checkPodSource(let podId, let source):
			params["podId"] = podId
			params["source"] = source
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		case .addPodSource(let podId, let feedUrl, let sourceType):
			params["podId"] = podId
			params["feedUrl"] = feedUrl
			params["sourceType"] = sourceType
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		default:
			return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
		}
    }
    
    
    public var baseURL: URL {
        return URL.init(string: FunnyFm.baseurl)!;
    }
    
    public var path: String {
        switch self {
        case .getPodList():
            return kGetPodListurl
		case .checkPodSource:
			return kCheckPodSourceUrl
		case .addPodSource(_, _, _):
			return kAddPodSourceUrl
		}
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPodList():
            return .get
        default:
            return .post
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
