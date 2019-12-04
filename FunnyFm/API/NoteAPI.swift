//
//  NoteAPI.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/2.
//  Copyright © 2019 Duke. All rights reserved.
//

import Foundation
import Moya



let kGetNotes = "v1/episode/getNotes"
let kCreateNotes = "v1/episode/createNote"

let noteProvider = MoyaProvider<NoteAPI>()

public enum NoteAPI {
	case getNotes(String)
	case createNotes([String: Any])
}

extension NoteAPI : TargetType {
    
    //请求接口时对应的请求参数
    public var task: Task {
        var params:[String : Any] = [:]
        switch self {
		case .getNotes(let trachUrl):
			params["track_url"] = trachUrl
			params["user_id"] = UserCenter.shared.userId
            break;
		case .createNotes(let param):
			params = param
			params["user_id"] = UserCenter.shared.userId
			break;
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    
    public var baseURL: URL {
        return URL.init(string: FunnyFm.baseurl)!;
    }
    
    public var path: String {
        switch self {
        case .getNotes:
            return kGetNotes
		case .createNotes:
			return kCreateNotes
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .createNotes,
			 .getNotes:
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

