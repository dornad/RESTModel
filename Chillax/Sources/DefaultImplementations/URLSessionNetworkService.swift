//
//  URLSessionNetworkService.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 Paperless Post. All rights reserved.
//

import Foundation

internal enum JSONResult {
    case success (JSON)
    case error (Error)
}

internal enum HTTPResult {
    case success (Data)
    case error (Error)
}

internal enum NetworkManagerError: Error {
    case noURLForOperation
    case noData
    case invalidResponse
    case responseStatus (status: Int)
    case failedRequest (cause:Error)
    case incorrectJSON
    case unknown (Error)
}

public class URLSessionNetworkService <T:ResourceRepresentable> : NetworkService {

    internal typealias RequestFunctionType = (ChillaxOperation, @escaping (HTTPResult) -> Void) -> NetworkServiceOperation

    internal var _requestFunction: (RequestFunctionType)!

    public func perform(operation: ChillaxOperation, callback: @escaping (Result<T>) -> Void) -> NetworkServiceOperation {

        let networkServiceOperation = _requestFunction(operation) { result in

            switch result {
            case .success(let data):
                
                guard operation.expectsJSONResponse else {
                    
                    callback( Result.success([]))
                    return
                }

                let json = T.resourceInformation.parse(data: data)

                switch json {

                case .dictionary(let dict):

                    let output = try! T(data: dict)
                    callback( Result.success( [output] ) )

                case .array(let array):

                    let output = array.flatMap { (dict) -> T? in
                        return try? T(data:dict)
                    }
                    callback( Result.success( output ) )
                    
                case .notJSON(let details):
                    
                    callback(Result.error(details))
                }

            case .error(let error):

                callback(Result.error(error))
            }
        }
        
        return networkServiceOperation
    }


    public init() {
        _requestFunction = _httpRequest
    }
}
