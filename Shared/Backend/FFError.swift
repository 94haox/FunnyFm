//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 22/07/2020.
//

import Foundation
import Combine

public struct FFError: Decodable {
    public let message: String?
    public let error: Int?
    
    static public func processNetworkError(error: NetworkError) -> FFError {
        switch error {
        case let .ffAPIError(error, _):
            return error
        default:
            return FFError(message: "Unknown error", error: -999)
        }
    }
}

