//
//  ChillaxOperation.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/27/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation
@testable import Chillax

//enum HTTPMethod: String {
//    case options = "OPTIONS"
//    case get     = "GET"
//    case head    = "HEAD"
//    case post    = "POST"
//    case put     = "PUT"
//    case patch   = "PATCH"
//    case delete  = "DELETE"
//    case trace   = "TRACE"
//    case connect = "CONNECT"
//}
//
//protocol ChillaxOperation {
//    
//    var httpMethod: HTTPMethod { get }
//    
//    var httpHeaderFields: [String:String] { get }
//    
//    var urlComponents: URLComponents { get }
//    
//    var httpBody: Data? { get }
//}
//
//
//
//private enum RequestBuilderError: Int, Error {
//    case urlIsNil = 0
//    case jsonIsNil
//    case httpBodyIsNil
//}
//
//
//extension RESTResource {
//    
//    func request(for operation: ChillaxOperation) throws -> URLRequest {
//        
//        guard let url = operation.urlComponents.url else { throw RequestBuilderError.urlIsNil }
//        
//        var request = URLRequest(url: url)
//        
//        request.httpMethod = operation.httpMethod.rawValue
//        
//        // http header fields
//        
//        operation.httpHeaderFields.forEach {
//            request.addValue($1, forHTTPHeaderField: $0)
//        }
//        
//        // body
//        
//        if let httpBody = operation.httpBody {
//            request.httpBody = httpBody
//        }
//        
//        return request
//    }
//}
//
//extension NetworkService {
//    
//    func perform(operation: ChillaxOperation, callback: @escaping (Result<T>) -> Void) -> NetworkServiceOperation {
//        
//        return NetworkServiceOperationStub.init()
//        
//    }
//    
//    
//    
//    
//    
//}


