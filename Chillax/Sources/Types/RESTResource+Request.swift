//
//  RESTResource+Request.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation

extension RESTResource {
    
    internal func request(for operation: ChillaxOperation) throws -> URLRequest {
        
        guard let url = operation.urlComponents.url else { throw RequestBuilderError.urlIsNil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = operation.httpMethod.rawValue
        
        // http header fields
        
        operation.httpHeaderFields.forEach {
            request.addValue($1, forHTTPHeaderField: $0)
        }
        
        // body
        
        if let httpBody = operation.httpBody {
            request.httpBody = httpBody
        }
        
        return request
    }

}

private enum RequestBuilderError: Int, Error {    
    case urlIsNil = 0
    case jsonIsNil
    case httpBodyIsNil
}

