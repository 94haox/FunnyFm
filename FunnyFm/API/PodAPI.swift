//
//  PodApi.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import Moya



let kGetPodListurl = "v1/user/subscribeList"
let kCheckPodSourceUrl = "v1/checkPodSource"
let kCheckNeteasePodSourceUrl = "v1/netease/podInfo"
let kAddPodSourceUrl = "v1/addPodSource"
let kSearchPodUrl = "v1/pod/searchPod"
let kRegisterPodUrl = "v1/pod/registerPod"
let kParserRssUrl = "v1/pod/parser"




let apiProvider = MoyaProvider<PodAPI>()

public enum PodAPI {
	case getPodList
	case checkPodSource(String, String)
	case addPodSource(String, String, String)
	case searchPod(String)
	case searchTopic(String)
	case parserRss(Dictionary<String, String>)
	case registerPod(Dictionary<String, String>)
}

extension PodAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        var params:[String : Any] = [:]
		switch self {
		case .checkPodSource(let podId, let source):
			if source == "netease"{
				params["rid"] = podId
			}else{
				params["podId"] = podId
				params["source"] = source
			}
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		case .addPodSource(let podId, let feedUrl, let sourceType):
			params["podId"] = podId
			params["feedUrl"] = feedUrl
			params["sourceType"] = sourceType
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		case .searchPod(let keyWord):
			params["term"] = keyWord
			params["limit"] = "20"
			params["media"] = "podcast"
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		case .searchTopic(let keyWord):
			params["term"] = "podcast"
			params["genreId"] = keyWord
			params["limit"] = "50"
			params["country"] = Locale.current.regionCode
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		case .registerPod(let param):
			params = param
			if UserCenter.shared.isLogin {
				params["user_id"] = UserCenter.shared.userId
			}
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		case .getPodList:
			params["user_id"] = UserCenter.shared.userId
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		case .parserRss(let param):
			params = param
			return .requestParameters(parameters: params, encoding: JSONEncoding.default)
		}
    }
    
    
    public var baseURL: URL {
		switch self {
		default:
			return URL.init(string: FunnyFm.baseurl)!
		}
    }
    
    public var path: String {
        switch self {
        case .getPodList:
            return kGetPodListurl
		case .checkPodSource(_ ,let source):
			if source == "netease" {
				return kCheckNeteasePodSourceUrl
			}
			return kCheckPodSourceUrl
		case .addPodSource(_, _, _):
			return kAddPodSourceUrl
		case .searchPod(_), .searchTopic(_):
			return kSearchPodUrl;
		case .registerPod(_):
			return kRegisterPodUrl
		case .parserRss(_):
			return kParserRssUrl
		}
    }
    
    public var method: Moya.Method {
        switch self {
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
