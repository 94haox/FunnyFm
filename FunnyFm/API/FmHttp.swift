//
//  FmHttp.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Moya
//import RxMoya
import SwiftyJSON
import Result


public protocol Mapable {
    init?(jsonData:JSON)
}

public class FmHttp<T> where T: Mapable{
    
    ///成功
    typealias SuccessStringClosure = (_ result: String) -> Void
    typealias SuccessModelClosure = (_ result: T?) -> Void
    typealias SuccessArrModelClosure = (_ result: [T]?) -> Void
    typealias SuccessJSONClosure = (_ result:JSON) -> Void

    
    /// 失败
    typealias FailClosure = (_ errorMsg: String?) -> Void
    
    var tasks : [URLSessionTask]!
    
    
    func requestForArray<R:TargetType>(_ type:R,
                                       _ success: @escaping SuccessArrModelClosure,
                                       _ failure: @escaping FailClosure)
    {
        let provider = MoyaProvider<R>()
        provider.request(type) { (result) in
            switch result {
            case .success(let response):
                do{
                    let jsondata = try response.mapJSON()
                    let json = JSON(jsondata)
                    let code = json["data"]["code"]
                    if code.intValue != 0 {
                        failure(json["message"].string)
                        return
                    }
                    let jsonlist = json["data"]["items"].array!
                    var models = [T]()
                    jsonlist.forEach({ (item) in
                        let t = T.init(jsonData:item)!
                        models.append(t)
                    })
                    success(models)
                }catch{
                    print("数据解析失败")
                    failure("数据解析失败")
                }
            case .failure(_):
                print("error")
                failure("未连接到服务器")
            }
        }
    }
    
    func requestForSingle<R:TargetType>(_ type:R,success:@escaping SuccessModelClosure,
                                        _ failure: @escaping FailClosure){
        let provider = MoyaProvider<R>()
        provider.request(type) { (result) in
            switch result {
            case .success(let data):
                do{
                    let jsondata = try data.mapJSON()
                    let json = JSON(jsondata)
                    let detail = JSON(jsondata)["data"]["detail"]
                    let code = JSON(jsondata)["data"]["code"]
                    if code.intValue != 0 {
                        failure(json["message"].string)
                        return
                    }
                    let t = T.init(jsonData:detail)!
                    success(t)
                }catch{
                    failure("数据解析失败")
                }
            case .failure(_):
                print("error")
                failure("未连接到服务器")
            }
        }
    }
    
}
