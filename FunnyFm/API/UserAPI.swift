//
//  UserAPI.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/7.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import Moya



let kLoginUrl = "v1/user/login"
let kRegisterUrl = "v1/user/register"
let kUpdateInfo = "v1/user/updateInfo"
let kAddFavour = "v1/user/favour"
let kDissFavour = "v1/user/disFavour"
let kAddSubscribe = "v1/user/subscribe"
let kDisSubscribe = "v1/user/disSubscribe"
let kSubscribeList = "v1/user/subscribeList"
let kFavourList = "v1/user/favourList"


let UserProvider = MoyaProvider<UserAPI>()

public enum UserAPI {
    case login(String,String)
    case register(String,String)
    case addFavour(String)
    case disFavour(String)
    case addSubscribe(String)
    case disSubscribe(String)
    case getFavourList(String)
    case getSubscribeList(String)
}

extension UserAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        var params:[String : Any] = [:]
        switch self {
        case .login(let mail,let password),.register(let mail, let password):
            params["mail"] = mail
            params["password"] = password
            params["type"] = "email"
            break;
        case .addFavour(let episodeId), .disFavour(let episodeId):
            params["user_id"] = UserCenter.shared.userId
            params["episode_id"] = episodeId
            break
        case .addSubscribe(let podId),.disSubscribe(let podId):
            params["user_id"] = UserCenter.shared.userId
            params["pod_id"] = podId
            break
        case .getFavourList(let userId),.getSubscribeList(let userId):
            params["user_id"] = userId
            break
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    
    public var baseURL: URL {
        return URL.init(string: FunnyFm.baseurl)!;
    }
    
    public var path: String {
        switch self {
        case .login(_):
            return kLoginUrl
        case .register(_):
            return kRegisterUrl
        case .addFavour(_):
            return kAddFavour
        case .disFavour(_):
            return kDissFavour
        case .addSubscribe(_):
            return kAddSubscribe
        case .disSubscribe(_):
            return kDisSubscribe
        case .getFavourList(_):
            return kFavourList
        case .getSubscribeList(_):
            return kSubscribeList
        }
        
    }
    
    public var method: Moya.Method {
        return .post
        
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

