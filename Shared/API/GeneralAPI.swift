//
//  GeneralAPI.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import Moya



let kGetAllMessage = "v1/message/allMessages"
let kGetVersion = "v1/general/getVersion"
let kGetRecommends = "v1/discover/recommends"

let generalProvider = MoyaProvider<GeneralAPI>()

public enum GeneralAPI {
    case getAllMessage
	case getVersion
	case getRecommends
}

extension GeneralAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        let params:[String : Any] = [:]
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    
    public var baseURL: URL {
        return URL.init(string: FunnyFm.baseurl)!;
    }
    
    public var path: String {
        switch self {
        case .getAllMessage:
            return kGetAllMessage
		case .getVersion:
			return kGetVersion
		case .getRecommends:
			return kGetRecommends
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .getAllMessage,
			 .getRecommends,
			 .getVersion:
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

