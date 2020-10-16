//
//  FmHttp.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
//import Result
///成功
typealias SuccessStringClosure = (_ result: String) -> Void
typealias SuccessJSONClosure = (_ result:JSON) -> Void
/// 失败
typealias FailClosure = (_ errorMsg: String?) -> Void

public class FmHttp<T> where T: Mapable{
	
	typealias SuccessModelClosure = (_ result: T?) -> Void
	typealias SuccessArrModelClosure = (_ result: [T]?) -> Void
	typealias SuccessJsonClosure = (_ result: JSON) -> Void
	
    var tasks : [URLSessionTask]!
    
    func requestForArray<R:TargetType>(_ type:R,
                                       _ success: @escaping SuccessArrModelClosure,
                                       _ failure: @escaping FailClosure){
		self.requestForArray(type, true, success, failure)
    }
    
    func requestForSingle<R:TargetType>(_ type:R,
										_ success:@escaping SuccessModelClosure,
                                        _ failure: @escaping FailClosure){
		self.requestForSingle(type, true, success, failure)
    }
	
    func requestForSingleWithoutParser<R:TargetType>(_ type:R,
										_ success:@escaping SuccessModelClosure,
                                        _ failure: @escaping FailClosure){
		self.requestForSingle(type, false, success, failure)
    }
	
	
	func requestForItunes<R:TargetType>(_ type:R,
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
					let count = json["resultCount"]
					if count.intValue < 1 {
						failure("无结果")
						return
					}
					let jsonlist = json["results"].array!
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
	
	func requestForArray<R:TargetType>(_ type:R,
									  _ needParser: Bool,
									  _ success: @escaping SuccessArrModelClosure,
									  _ failure: @escaping FailClosure){
		let provider = MoyaProvider<R>()
        provider.request(type) { (result) in
			#if os(iOS) && canImport(WCDBSwift)
			Hud.shared.hide()
			#endif
            switch result {
            case .success(let response):
                do{
                    let jsondata = try response.mapJSON()
                    let json = JSON(jsondata)
                    let code = json["code"].intValue
                    if code != 0 {
                        failure(json["message"].string)
                        return
                    }
					if needParser {
						let jsonlist = json["data"]["items"].arrayValue
						var models = [T]()
						jsonlist.forEach({ (item) in
							let t = T.init(jsonData:item)!
							models.append(t)
						})
						success(models)
					}else{
						success(nil)
					}
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
	
	
	func requestForSingle<R:TargetType>(_ type:R,
									   _ needParser: Bool,
									   _ success:@escaping SuccessModelClosure,
									   _ failure: @escaping FailClosure){
		let provider = MoyaProvider<R>()
        provider.request(type) { (result) in
			#if os(iOS) && canImport(WCDBSwift)
			Hud.shared.hide()
			#endif
            switch result {
            case .success(let data):
                do{
                    let jsondata = try data.mapJSON()
                    let json = JSON(jsondata)
                    let code = json["code"]
					let resultCode = json["result"]
                    if code.intValue != 0 || resultCode.intValue != 1 {
                        failure(json["message"].string)
                        return
                    }
					if needParser {
						let detail = json["data"]["detail"]
						let t = T.init(jsonData:detail)!
						success(t)
					}else{
						success(nil)
					}
                }catch{
                    failure("数据解析失败")
                }
            case .failure(_):
                print("error")
                failure("未连接到服务器")
            }
        }
	}
	
	
	func requestForSingle<R:TargetType>(_ type:R,
									   _ success:@escaping SuccessJsonClosure,
									   _ failure: FailClosure?){
		let provider = MoyaProvider<R>()
        provider.request(type) { (result) in
			#if os(iOS) && canImport(WCDBSwift)
			Hud.shared.hide()
			#endif
            switch result {
            case .success(let data):
                do{
                    let jsondata = try data.mapJSON()
                    let json = JSON(jsondata)
                    let code = json["code"]
					let resultCode = json["result"]
                    if code.intValue != 0 || resultCode.intValue != 1 {
						if failure != nil {
							failure!(json["message"].string)
						}else{
							#if os(iOS) && canImport(WCDBSwift)
							SwiftNotice.showText(json["message"].stringValue)
							#endif
						}
                        return
                    }
					success(json)
                }catch{
					if failure != nil {
						failure!("数据解析失败")
					}else{
						#if os(iOS) && canImport(WCDBSwift)
						SwiftNotice.showText("数据解析失败")
						#endif
					}
                }
            case .failure(_):
                print("error")
				if failure != nil {
					failure!("未连接到服务器")
				}else{
					#if os(iOS) && canImport(WCDBSwift)
					SwiftNotice.showText("网络貌似有些问题，请稍候重试")
					#endif
				}
            }
        }
	}
	
	
	
	
    
}
