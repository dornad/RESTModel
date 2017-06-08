//
//  ResourceRepresentableConfiguration.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 Paperless Post. All rights reserved.
//

import Foundation

/// Holds information about how to convert a `ResourceRepresentable` into its RESTful resource.
public protocol ResourceRepresentableConfiguration {
    
    /// A structure containing configuration values.  These configuration values can be global or 
    /// local to the current `ResourceRepresentableConfiguration`.
    var configuration: Configuration { get set }
    
    /// A URLComponents instance
    ///
    /// Recommended that it contains values for scheme, port, host and path
    var rootURLComponents: URLComponents { get }
}



// MARK: URLRequest providing

extension ResourceRepresentableConfiguration {
    
    /// Provides a URLRequest instance matchin the specified Operation
    ///
    /// - Parameter operation: The Chillax Operation
    /// - Returns: A URLRequest
    /// - Throws: RequestBuilderError.urlIsNil
    internal func request(for operation: ChillaxOperation) throws -> URLRequest {
        
        guard let url = operation.urlComponents.url else { throw RequestBuilderError.urlIsNil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = operation.httpMethod.rawValue
        
        // http header fields
        
        operation.httpHeaderFields.forEach { headerField in
            request.addValue(headerField.value, forHTTPHeaderField: headerField.key)
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


