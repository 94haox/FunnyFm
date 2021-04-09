//
//  API.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation
import Combine

public class API {
    static public let shared = API()
    static private let HOST = FunnyFm.baseurl
    
    private var session: URLSession
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        session = URLSession(configuration: Self.makeSessionConfiguration(token: nil))
    }
    
    static private func makeSessionConfiguration(token: String?) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        var headers: [String:String] = [:]
        headers["os"] = "iOS"
        headers["version"] = "0.1"
        headers["Content-type"] = "application/json"
        configuration.httpAdditionalHeaders = headers
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        return configuration
    }
    
    static private func makeURL(endpoint: Endpoint) -> URL {
        var url: URL = URL(string: Self.HOST)!
        url = url.appendingPathComponent(endpoint.path())
        let component = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    public func request<T: Decodable>(endpoint: Endpoint,
                                      httpMethod: String = "GET",
                                      queryParamsAsBody: Bool = false,
                                      params: [String: String]? = nil) -> AnyPublisher<T ,NetworkError> {
        var url = Self.makeURL(endpoint: endpoint)
        var request: URLRequest
        if let params = params {
            if queryParamsAsBody {
                var urlComponents = URLComponents()
                urlComponents.queryItems = []
                for (_, param) in params.enumerated() {
                    urlComponents.queryItems?.append(URLQueryItem(name: param.key, value: param.value))
                }
                request = URLRequest(url: url)
                request.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
                request.setValue("application/x-www-form-urlencoded",forHTTPHeaderField: "Content-Type")
            } else {
                for (_, value) in params.enumerated() {
                    url = url.appending(value.key, value: value.value)
                }
                request = URLRequest(url: url)
            }
        } else {
            request = URLRequest(url: url)
        }
        request.httpMethod = httpMethod
        return session.dataTaskPublisher(for: request)
            .tryMap{ data, response in
                return try NetworkError.processResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: decoder)
            .mapError{ error in
                print("----- BEGIN PARSING ERROR-----")
                print(error)
                print("----- END PARSING ERROR-----")
                return NetworkError.parseError(reason: error)
            }
            .eraseToAnyPublisher()
    }
    
    public func POST<T: Decodable>(endpoint: Endpoint,
                                   params: [String: String]? = nil) -> AnyPublisher<T ,NetworkError> {
        request(endpoint: endpoint,
                httpMethod: "POST",
                queryParamsAsBody: true,
                params: params)
    }
}
