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

let UserProvider = MoyaProvider<UserAPI>()

public enum UserAPI {
    case login(String,String)
    case register(String,String)
}

extension UserAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        var params:[String : Any] = [:]
        switch self {
        case .login(let mail,let password):
            params["mail"] = mail
            params["password"] = password
            break;
        case .register(let mail, let password):
            params["mail"] = mail
            params["password"] = password
            break;
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

