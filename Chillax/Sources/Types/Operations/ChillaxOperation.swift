//
//  ChillaxOperation.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/28/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

public protocol ChillaxOperation {
    
    var httpMethod: HTTPMethod { get }
    
    var httpHeaderFields: [String:String] { get }
    
    var urlComponents: URLComponents { get }
    
    var httpBody: Data? { get }
    
    var expectsJSONResponse: Bool { get }
    
    var encoder: JSONEncoder { get }
    
    var decoder: JSONDecoder { get }
}

extension ChillaxOperation {
    
    public var encoder: JSONEncoder {
        return JSONEncoder()
    }
    
    public var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
}



